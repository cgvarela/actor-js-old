ByteBuffer = dcodeIO.ByteBuffer
Long = dcodeIO.Long

class Codec
  @encode: (obj, buf) ->
  @decode: (obj) ->
  @decodeValue: (obj) ->
    @decode(obj)._1

ByteBuffer.alloc = (buf, size) ->
  if buf
    buf._chain = true
    buf
  else
    new ByteBuffer(size)

ByteBuffer::flipChain = () ->
  if not @_chain
    @flip()

class Tuple2
  constructor: (@value, @remain) ->
    @_1 = value
    @_2 = remain

tuple2 = (value, remain) -> new Tuple2(value, remain)

parseLong = (obj) ->
  if obj instanceof Long
    obj
  else if _.isNumber(obj)
    Long.fromInt(obj)
  else if _.isString(obj)
    Long.fromString(obj)
  else
    throw new Error("Unknown type instance '#{typeof obj}': #{obj}")


class VarIntCodec extends Codec
  @maxSize: 10

  @encode: (obj, buf) ->
    long = parseLong(obj)
    buf = ByteBuffer.alloc(buf, @maxSize)
    while long.greaterThan(0x7f)
      buf.writeByte(long.and(0xff).or(0x80).toInt())
      long = long.shiftRight(7)
    buf.writeByte(long.toInt())
    buf.flipChain()
    buf

  @decode: (buf) ->
    f = (position, acc, maxSize) ->
      if position > buf.limit
        acc
      else
        if position > maxSize then throw new Exception("Exceeded max size of var int")
        b = buf.readByte() & 0xff
        n = Long.fromInt((b & 0x7f)).shiftLeft(7 * position)
        res = acc.xor(n)
        if b > 0x7f
          f(position + 1, res)
        else
          res
    tuple2(f(0, new Long(), @maxSize), buf)

  @decodeInt: (buf) ->
    res = @decode(buf)
    tuple2(res._1.toInt(), res._2)

class StringCodec extends Codec
  @encode: (str, buf) ->
    buf = ByteBuffer.alloc(buf)
    buf.append(VarIntCodec.encode(str.length))
    buf.append(str)
    buf.flipChain()
    buf

  @decode: (buf) ->
    l = VarIntCodec.decodeInt(buf)
    tuple2(l._2.readUTF8String(l._1), l._2)

class BoolCodec extends Codec
  @encode: (val, buf) ->
    buf = ByteBuffer.alloc(buf)
    buf.writeByte(if (val is true) then 1 else 0)
    buf.flipChain()
    buf

  @decode: (buf) ->
    tuple2(buf.readByte() == 1, buf)

class BytesCodec extends Codec
  @encode: (obj, buf) ->
    len =
      if _.isString(obj)
        obj.length
      else if obj instanceof ByteBuffer
        obj = obj.clone().flip()
        obj.limit
      else
        throw new Error("Unknown type instance '#{typeof obj}': #{obj}")
    buf = ByteBuffer.alloc(buf)
    VarIntCodec.encode(len, buf)
    buf.append(obj.slice(0, len))
    buf.flipChain()
    buf

  @decode: (buf) ->
    l = VarIntCodec.decodeInt(buf)
    tuple2(l._2.slice(l._2.offset, l._2.offset + l._1), l._2.slice(l._2.offset + l._1))

class LongCodec extends Codec
  @encode: (obj, buf) ->
    buf = ByteBuffer.alloc(buf)
    buf.writeLong(parseLong(obj))
    buf.flipChain()
    buf

  @decode: (buf) ->
    tuple2(buf.readLong(), buf)

class LongsCodec extends Codec
  @encode: (arr, buf) ->
    buf = ByteBuffer.alloc(buf)
    buf.append(VarIntCodec.encode(arr.length))
    _.each(arr, (l) -> buf.append(LongCodec.encode(l)))
    buf.flipChain()
    buf

  @decode: (buf) ->
    arr = []
    l = VarIntCodec.decodeInt(buf)
    i = l._1
    while i-- > 0
      arr.push(l._2.readLong())
    tuple2(arr, l._2)

class Int32Codec extends Codec
  @encode: (n, buf) ->
    buf = ByteBuffer.alloc(buf)
    buf.writeInt32(n)
    buf.flipChain()
    buf

  @decode: (buf) ->
    tuple2(buf.readInt32(), buf)

class Int8Codec extends Codec
  @encode: (n, buf) ->
    buf = ByteBuffer.alloc(buf)
    buf.writeUint8(n)
    buf.flipChain()
    buf

  @decode: (buf) ->
    tuple2(buf.readUint8(), buf)

bool = BoolCodec
bytes = BytesCodec
longs = LongsCodec
long = LongCodec
string = StringCodec
int32 = Int32Codec
int8 = Int8Codec
varint = VarIntCodec

#(field_number << 3) | wire_type

scope = @

class Protobuf
  @PROTOBUF_TYPES:
    VARINT: 0
    BITS64: 1
    LENGTH: 2
    BITS32: 5

  @PROTOBUF_TYPE_ALIASES:
    int32: @PROTOBUF_TYPES.VARINT
    uint32: @PROTOBUF_TYPES.VARINT
    int64: @PROTOBUF_TYPES.VARINT
    uint64: @PROTOBUF_TYPES.VARINT
    bool: @PROTOBUF_TYPES.VARINT
    float: @PROTOBUF_TYPES.BITS32
    double: @PROTOBUF_TYPES.BITS64
    string: @PROTOBUF_TYPES.LENGTH
    bytes: @PROTOBUF_TYPES.LENGTH

  @encode: (obj, stream) ->
    schema = obj.constructor.schema
    throw new Error("Schema can't be empty") unless schema
    stream = new ByteBuffer() unless stream
    for item, field of schema
      fieldNumber = field.n || throw new Error("Empty field number")
      rule = field.rule || throw new Error("Empty field rule")
      f = (value) =>
        switch field.type
          when "int32", "uint32"
            @writeVarInt(fieldNumber, value, stream)
          when "int64", "uint64"
            @writeVarInt(fieldNumber, value, stream)
          when "float" then @writeFloat32(fieldNumber, value, stream)
          when "double" then @writeFloat64(fieldNumber, value, stream)
          when "bool" then @writeVarInt(fieldNumber, (if value then 1 else 0), stream)
          when "string" then @writeBytes(fieldNumber, value, stream)
          when "bytes" then @writeBytes(fieldNumber, value, stream)
          else
            if value.encode?
              @writeBytes(fieldNumber, value.encode(), stream)
            else if scope[field.type].schema? && scope[field.type].schema instanceof Array
              @writeVarInt(fieldNumber, value, stream)
            else
              throw new Error("Unknown type: #{field.type}; method encode not found, can't be serialized")
      switch rule
        when "required" then f(obj[item])
        when "optional" then f(obj[item]) if obj[item]?
        when "repeated" then obj[item].forEach((value) -> f(value))
        else throw new Error("Unknown rule: #{rule}")
    stream.flipChain()
    stream

  @integerTypes: ['int32', 'int64', 'uint32', 'unit64', 'sint32', 'sint64']

  @decode: (klass, stream) ->
    schema = scope[klass].schema
    throw new Error("Schema can't be empty") unless schema
    tagSchema = scope[klass].tagSchema
    unless tagSchema?
      tagSchema = {}
      for item, field of schema
        fieldNumber = field.n || throw new Error("Empty field number")
        type = field.type || throw new Error("Empty field type")
        typeAlias =
          if @PROTOBUF_TYPE_ALIASES[type]?
            @PROTOBUF_TYPE_ALIASES[type]
          else
            if scope[type].decode?
              @PROTOBUF_TYPES.LENGTH
            else if scope[type].schema? && scope[type].schema instanceof Array
              @PROTOBUF_TYPES.VARINT
            else
              throw new Error("Unknown type: #{type}; method decode not found, can't be serialized")
        tagSchema[fieldNumber] =
          rule: field.rule || throw new Error("Empty field rule")
          type: type
          typeAlias: typeAlias
          column: item
          isInteger: @integerTypes.indexOf(type) != -1
      scope[klass].tagSchema = tagSchema

    obj = new scope[klass]

    readTag = () ->
      res = stream.readByte()
      if res < 0 then 0 else res & 0xff

    readValue = (type) =>
      switch type
        when "int32", "uint32"
          @readVarInt(stream).toNumber()
        when "int64", "uint64"
          @readVarInt(stream)
        when "float" then @readFloat32(stream)
        when "double" then @readFloat64(stream)
        when "bool" then @readVarInt(stream).toNumber() == 1
        when "string" then @readBytes(stream).toUTF8()
        when "bytes" then @readBytes(stream)
        else
          if scope[type]? && scope[type].decode?
            scope[type].decode(@readBytes(stream))
          else if scope[type].schema? && scope[type].schema instanceof Array
            @readVarInt(stream).toNumber()
          else
            throw new Error("Unknown type: #{type}; method decode not found, can't be serialized")

    put = (value, fieldSchema) =>
      if fieldSchema.rule == "repeated"
        obj[fieldSchema.column] ||= []
        obj[fieldSchema.column].push(value)
      else
        obj[fieldSchema.column] = value

    console.log("decode:")
    stream.printDebug()
    while (stream.remaining() > 0 && (currentTag = readTag()) > 0)
      id = currentTag >> 3
      type = currentTag & 0x07
      console.log("currentTag:",currentTag,"id:",id,"type:", type)
      fieldSchema = tagSchema[id]
      console.log("fieldSchema:",fieldSchema)
      if fieldSchema
        if fieldSchema.typeAlias == type
          put(readValue(fieldSchema.type), fieldSchema)
        else if fieldSchema.isInteger && type == @PROTOBUF_TYPES.VARINT # || type == @PROTOBUF_TYPES.BITS32 || type == @PROTOBUF_TYPES.BITS64)
          value = @readVarInt(stream)
          if fieldSchema.type.matches("int64$") then put(value, fieldSchema)
          else put(value.toNumber(), fieldSchema)
        else
          stream.printDebug()
          console.error("#{klass}.#{fieldSchema.column} has different type than in stream: #{fieldSchema.typeAlias} vs #{type}")
          throw new Error("#{klass}.#{fieldSchema.column} has different type than in stream: #{fieldSchema.typeAlias} vs #{type}")
      else
        console.error("fieldSchema is unknown!")
        throw new Error("fieldSchema is unknown!")

    for column, field of schema
      if field.rule == "required" && !obj[column]?
        throw new Error("#{klass}.#{column} is empty but it's required by schema")
      else if field.rule == "optional" && obj[column] == undefined
        obj[column] = null
      else if field.rule == "repeated" && !obj[column]?
        obj[column] = []
    obj


  @writeTag: (fieldNumber, wireType, stream) ->
    tag = (fieldNumber << 3) | wireType
    stream.writeByte(tag)

  # int32, int64, uint32, uint64, sint32, sint64, bool, enum
  @writeVarInt: (fieldNumber, value, stream) ->
    @writeTag(fieldNumber, @PROTOBUF_TYPES.VARINT, stream)
    varint.encode(value, stream)

  # string, bytes, embedded messages, packed repeated fields
  @writeBytes: (fieldNumber, value, stream) ->
    @writeTag(fieldNumber, @PROTOBUF_TYPES.LENGTH, stream)
    bytes.encode(value, stream)

  # fixed32, sfixed32, float
  @writeInt: (fieldNumber, value, stream) ->
    @writeTag(fieldNumber, @PROTOBUF_TYPES.BITS32, stream)
    int32.encode(value, stream)

  # fixed64, sfixed64, double
  @writeLong: (fieldNumber, value, stream) ->
    @writeTag(fieldNumber, @PROTOBUF_TYPES.BITS64, stream)
    long.encode(value, stream)

  # float
  @writeFloat32: (fieldNumber, value, stream) ->
    @writeTag(fieldNumber, @PROTOBUF_TYPES.BITS32, stream)
    stream.writeFloat32(value)

  # double
  @writeFloat64: (fieldNumber, value, stream) ->
    @writeTag(fieldNumber, @PROTOBUF_TYPES.BITS64, stream)
    stream.writeFloat64(value)

  @readVarInt: (stream) ->
    varint.decode(stream).value

  @readBytes: (stream) ->
    length = varint.decodeInt(stream).value
    res = stream.copy(stream.offset, stream.offset + length)
    stream.skip(length)
    res

  @readFloat32: (stream) ->
    stream.readFloat32(value)

  @readFloat64: (stream) ->
    stream.readFloat64(value)

class MTPackageBox
  constructor: (@id, @package) ->

  encode: (bodyBuf) ->
    bodyBuf = ByteBuffer.alloc(bodyBuf)
    body = @package.encode()
    body.flip()
    len = 8 + body.limit # int size + crc size
    int32.encode(len, bodyBuf)
    int32.encode(@id, bodyBuf)
    bodyBuf.append(body)
    bodyBuf.flip()
    bodyAB = bodyBuf.buffer.slice(0, bodyBuf.limit)
    crc = CRC32.buf(new Uint8Array(bodyAB))
    buf = new ByteBuffer()
    buf.append(bodyAB)
    int32.encode(crc, buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    len = int32.decode(buf).value
    # new MTPackageBox(body[0], body[1], MessageBox.deserialize(body[2]))


class MTPackage
  constructor: (@authId, @sessionId, @body) ->

  encode: (buf) ->
    console.log("MTPackage:", @)
    buf = ByteBuffer.alloc(buf)
    long.encode(@authId, buf)
    long.encode(@sessionId, buf)
    @body.encode(buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    authId = long.decode(buf).value
    sessionId = long.decode(buf).value
    mb = MessageBox.decode(buf)
    new MTPackage(authId, sessionId, mb)


class MessageBox
  constructor: (@messageId, @body) ->

  encode: (buf) ->
    console.log("MessageBox:", @)
    buf = ByteBuffer.alloc(buf)
    long.encode(@messageId, buf)
    msg = TransportMessage.encode(@body)
    bytes.encode(msg, buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    messageId = long.decode(buf).value
    msgBody = bytes.decode(buf).value
    msg = TransportMessage.decode(msgBody)
    new MessageBox(messageId, msg)


class TransportMessage
  @encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    int8.encode(msg.constructor.header, buf)
    bytes.encode(msg.encode(), buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    header = int8.decode(buf).value
    child = [Ping, Pong, RpcRequestBox, RpcResponseBox, UpdateBox, MessageAck, UnsentMessage, UnsentResponse,
             RequestResend, Container, NewSession, Drop, RequestAuthId, ResponseAuthId]
    for klass in child
      return klass.decode(buf) if header == klass.header
    throw new Error("Unknown message header: #{header}")

      
class UpdateBox extends TransportMessage
  @header = 0x05
  constructor: (@body) ->

  @decode: (buf) ->
    new UpdateBox(UpdateBoxMessage.decode(buf))

    
class UnsentMessage extends TransportMessage
  @header = 0x07
  constructor: (@messageId, @length) ->

  encode: (buf) ->
    buf = ByteBuffer.alloc(buf)
    long.encode(@messageId, buf)
    int32.encode(@length, buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    messageId = long.decode(buf).value
    length = int32.decode(buf).value
    new UnsentMessage(messageId, length)

    
class NewSession extends TransportMessage
  @header = 0x0c
  constructor: (@sessionId, @messageId) ->

  @decode: (buf) ->
    sessionId = long.decode(buf)
    messageId = long.decode(buf)
    new NewSession(sessionId, messageId)

    
class Ping extends TransportMessage
  @header = 0x01
  constructor: (@randomId) ->

  encode: (buf) ->
    buf = ByteBuffer.alloc(buf)
    long.encode(@randomId, buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    randomId = long.decode(buf).value
    new Ping(randomId)

    
class RequestResend extends TransportMessage
  @header = 0x09
  constructor: (@messageId) ->

  encode: (buf) ->
    buf = ByteBuffer.alloc(buf)
    long.encode(@messageId, buf)
    buf.flipChain()
    buf

class RpcRequestBox extends TransportMessage
  @header = 0x03
  constructor: (@body) ->

  encode: (buf) ->
    buf = ByteBuffer.alloc(buf)
    RpcRequest.encode(@body, buf)
    buf.flipChain()
    buf

class Pong extends TransportMessage
  @header = 0x02
  constructor: (@randomId) ->

  encode: (buf) ->
    buf = ByteBuffer.alloc(buf)
    long.encode(@randomId, buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    randomId = long.decode(buf).value
    new Pong(randomId)

    
class UnsentResponse extends TransportMessage
  @header = 0x08
  constructor: (@messageId, @requestMessageId, @length) ->

  @decode: (buf) ->
    messageId = long.decode(buf).value
    requestMessageId = long.decode(buf).value
    length = int32.decode(buf).value
    new UnsentResponse(messageId, requestMessageId, length)

    
class MessageAck extends TransportMessage
  @header = 0x06
  constructor: (@messageIds) ->

  encode: (buf) ->
    buf = ByteBuffer.alloc(buf)
    longs.encode(@messageIds, buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    messageIds = longs.decode(buf)
    new MessageAck(messageIds)

    
class Drop extends TransportMessage
  @header = 0x0d
  constructor: (@messageId, @message) ->

  @decode: (buf) ->
    messageId = long.decode(buf).value
    message = string.decode(buf).value
    new Drop(messageId, message)

    
class RequestAuthId extends TransportMessage
  @header = 0xf0
  constructor: () ->

  encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    buf


class Container extends TransportMessage
  @header = 0x0a
  constructor: (@messages) ->

  encode: (buf) ->
    buf = ByteBuffer.alloc(buf)
    varint.encode(messages.length, buf)
    MessageBox.encode(buf) for i in [0..messages.length]
    buf.flipChain()
    buf

  @decode: (buf) ->
    size = varint.decode(buf).value
    messages = []
    messages.push(MessageBox.decode(buf).value) for i in [0..size]
    new Container(messages)

    
class RpcResponseBox extends TransportMessage
  @header = 0x04
  constructor: (@messageId, @body) ->

  @decode: (buf) ->
    messageId = long.decode(buf).value
    bodyBytes = bytes.decode(buf).value
    body = RpcResponse.decode(bodyBytes)
    new RpcResponseBox(messageId, body)

    
class ResponseAuthId extends TransportMessage
  @header = 0xf1
  constructor: (@authId) ->

  @decode: (buf) ->
    authId = long.decode(buf).value
    new ResponseAuthId(authId)


class RpcRequest
  @encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    int8.encode(msg.constructor.header, buf)
    msg.encode(buf)
    buf.flipChain()
    buf


class Request extends RpcRequest
  @header = 0x01
  constructor: (@body) ->

  encode: (buf) ->
    buf = ByteBuffer.alloc(buf)
    int32.encode(@body.constructor.header, buf)
    bytes.encode(@body.encode(), buf)
    buf.flipChain()
    buf


class RpcResponse
  @decode: (buf) ->
    header = int8.decode(buf).value
    child = [Ok, Error, ConnectionNotInitedError, FloodWait, InternalError]
    for klass in child
      return klass.decode(buf) if header == klass.header
    throw new Error("Unknown message header: #{header}")


class Ok extends RpcResponse
  @header = 0x01
  constructor: (@body) ->

  @decode: (buf) ->
    new Ok(RpcResponseMessage.decode(buf))


class Error extends RpcResponse
  @header = 0x02
  constructor: (@code, @tag, @userMessage, @canTryAgain, @data) ->

  @decode: (buf) ->
    code = int32.decode(buf).value
    tag = string.decode(buf).value
    userMessage = string.decode(buf).value
    canTryAgain = bool.decode(buf).value
    dataBytes = bytes.decode(buf).value
    # data = ErrorData.decode(dataBytes).value
    new Error(code, tag, userMessage, canTryAgain, data)

class ConnectionNotInitedError extends RpcResponse
  @header = 0x05

  @decode: (buf) ->
    new ConnectionNotInitedError()

class FloodWait extends RpcResponse
  @header = 0x03
  constructor: (@delay) ->

  @decode: (buf) ->
    delay = int32.decode(buf).value
    new FloodWait(delay)

class InternalError extends RpcResponse
  @header = 0x04
  constructor: (@body) ->

  @decode: (buf) ->
    canTryAgain = bool.decode(buf).value
    tryAgainDelay = int32.decode(buf).value
    new InternalError(canTryAgain, tryAgainDelay)

window.ActorMessages =
  Ping: Ping
  Pong: Pong
  RpcRequestBox: RpcRequestBox
  RpcResponseBox: RpcResponseBox
  UpdateBox: UpdateBox
  MessageAck: MessageAck
  UnsentMessage: UnsentMessage
  UnsentResponse: UnsentResponse
  RequestResend: RequestResend
  Container: Container
  NewSession: NewSession
  Drop: Drop
  RequestAuthId: RequestAuthId
  ResponseAuthId: ResponseAuthId
  MessageBox: MessageBox
  MTPackage: MTPackage
  MTPackageBox: MTPackageBox
  TransportMessage: TransportMessage
  RpcRequest: RpcRequest
  Request: Request
  RpcResponse: RpcResponse
  Ok: Ok
  Error: Error
  ConnectionNotInitedError: ConnectionNotInitedError
  FloodWait: FloodWait
  InternalError: InternalError
