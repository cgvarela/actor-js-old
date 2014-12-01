Long = dcodeIO.Long
PM = ProtobufActorMessages

ConnectionState =
  Connecting: 1
  Closing: 2

APIMessageListenerKind =
  TransportMessage: 1
  RpcResponse: 2
  UpdateMessage: 3

class APIMessageListeners
  # key (typeof parent class, TransportMessage for example) -> value (array of callbacks)
  listeners: {}

  # (err: string, message: Serializable, clear: () => void) => void
  push: (kind, f) ->
    @listeners[kind] ?= []
    @listeners[kind].push(f)

  apply: (mbox) ->
    if mbox.body instanceof ActorMessages.Container
      for msg in mbox.body.messages
        @applyMessage(msg.body)
    else
      @applyMessage(mbox.body)
    return

  applyMessage: (message) ->
    if message instanceof ActorMessages.UpdateBox
      console.log("UpdateBox: " + message)
      for f in @listeners[APIMessageListenerKind.UpdateBox]
        clear = false
        f(null, message, () -> clear = true)
        if clear
          break
    else
      messageKind =
        if message instanceof ActorMessages.RpcRequestBox
          throw new Error("Server can't send RpcRequestBox to client")
        else if message instanceof ActorMessages.RpcResponseBox
          APIMessageListenerKind.RpcResponse
        else if message instanceof ActorMessages.TransportMessage
          APIMessageListenerKind.TransportMessage
        else
          throw new Error("Unknown message kind: #{typeof message}")
      if @listeners[messageKind]
        for f, i in @listeners[messageKind]
          clear = false
          f(null, message, () -> clear = true)
          if clear
            @listeners[messageKind] = @listeners[messageKind].slice(0, i).concat(
              @listeners[messageKind].slice(i + 1, @listeners[messageKind].length))
            break
    return

class SecretAPI
  wsConnection: null
  wsUrl: "wss://mtproto-api.actor.im:9082" # "ws://localhost:8082" # "wss://mtproto-api.actor.im:9082"
  authId: null
  connectionState: ConnectionState.Connecting
  isAuthenticated: false
  sessionId: null
  clientMessageId: Long.fromNumber(0)
  # packageId: 0
  heartbeatInterval: null
  messageBuffer: []
  messageAcksBuffer: []
  receiveMessageListeners: new APIMessageListeners()
  deviceHash: "deviceHash"
  deviceTitle: "deviceTitle"
  appId: 0x03
  appKey: "appKey"

  MessageVersion: 1

  MessageType:
    TEXT: 0x01
    FILE: 0x02
    GEO: 0x03
    CONTACT: 0x04

  DataType:
    DECRYPTED: 0x01

  # TODO: reconnect with exponential backoff

  constructor: (authId) ->
    @setAuthId(authId)
    @connect()
    @startHeartbeat()

  setAuthId: (authId) ->
    if @isAuthenticated
      throw new Error("You should create new instance instead")
    else if @authId == authId
      throw new Error("Same authId: #{authId}")
    else if authId
      if authId != "0"
        @authId = authId
        @sessionId = @nextLong() # TODO
        @isAuthenticated = true
      else
        @authId = "0"
        @sessionId = "0"
    else
      throw new Error("invalid auth id")

  nextLong: () ->
    Long.fromString(forge.util.bytesToHex(forge.random.getBytesSync(8)), 16).toString()

  getAuthId: () -> @authId

  getSessionId: () -> @sessionId

  startHeartbeat: () ->
    @heartbeatInterval = setInterval(() =>
      if @isAuthenticated
        randomId = @nextLong()
        @enqueueTransportMessage new ActorMessages.Ping(randomId), (err, m, clear) ->
          clear()
          if err
            throw err
          else if m instanceof Pong and m.randomId == randomId
            console.log("Got pong with randomId: #{randomId}")
    , 10 * 60 * 1000)

  @requestAuthId: (f) ->
    ins = new SecretAPI("0")
    ins.requestAuthId (err, id) ->
      if (err)
        f(err, null)
      else
        f(null, new SecretAPI(id))
    ins

  requestAuthId: (f) ->
    @enqueueTransportMessage new ActorMessages.RequestAuthId(), (err, m, clear) =>
      if err
        f(err, null)
      else if m instanceof ActorMessages.ResponseAuthId
        clear()
        @setAuthId(m.authId)
        f(null, m.authId)

  makeMessageBox: (m) ->
    res = new MessageBox(@clientMessageId, m)
    @clientMessageId = @clientMessageId.add(4)
    res

  enqueueRpcMessage: (req, f) ->
    throw new Error("callback can't be empty") unless f?
    rpc = new ActorMessages.RpcRequestBox(new ActorMessages.Request(req))
    mb = @makeMessageBox(rpc)
    messageId = mb.messageId
    g = (messageId) ->
      (err, m, clear) ->
        if (err)
          f(err, null)
        else if m instanceof ActorMessages.RpcResponseBox and m.messageId.equals(messageId)
          clear()
          if m.body instanceof ActorMessages.Ok
            f(null, m.body.body)
          else
            f(m.body.toString(), null) # TODO
    @messageBuffer.push(mb)
    @receiveMessageListeners.push(APIMessageListenerKind.RpcResponse, g(messageId))
    @flushBuffers()

  enqueueTransportMessage: (m, f) ->
    mb = @makeMessageBox(m)
    @messageBuffer.push(mb)
    @receiveMessageListeners.push(APIMessageListenerKind.TransportMessage, f)
    @flushBuffers()

  addUpdateListener: (f) ->
    @receiveMessageListeners.push(APIMessageListenerKind.UpdateMessage, f)

  flushBuffers: () ->
    if @wsConnection && @wsConnection.readyState == WebSocket.OPEN
      messages = []

      if @messageAcksBuffer.length > 0
        messages.push(@makeMessageBox(new ActorMessages.MessageAck(@messageAcksBuffer)))
      if @messageBuffer.length > 0
        messages = messages.concat(@messageBuffer)

      mb =
        if messages.length > 1
          @makeMessageBox(new ActorMessages.Container(messages))
        else if messages.length == 1
          messages[0]

      if mb
        blob = @serializePackage(mb)
        blob.flip()
        blob.printDebug()
        buffer = blob.buffer.slice(0, blob.limit)
        console.log("blob.buffer:", blob.toHex())
        view = new Uint8Array(buffer)
        console.log("Uint8Array:", view)

        try
          @wsConnection.send(buffer)
          @messageAcksBuffer = []
          @messageBuffer = []
        catch err
          console.log("Error when flush buffers: #{err}")
    else
      console.log("this.wsConnection.readyState != WebSocket.OPEN")

  connect: () ->
    if @wsConnection
      @wsConnection.close()
    @wsConnection = new WebSocket(@wsUrl)
    @wsConnection.binaryType = "arraybuffer"
    @wsConnection.onopen = (event) =>
      console.log("onopen: ", event)
      @flushBuffers()
    @wsConnection.onerror = (event) =>
      console.log("onerror: ", event, @wsConnection)
    @wsConnection.onmessage = (event) =>
      console.log("onmessage: ", event)
      if event.data
        # pkg = MTPackageBox.decode(ByteBuffer.wrap(event.data))
        pkg = MTPackage.decode(ByteBuffer.wrap(event.data))
        console.log(pkg)
        @receiveMessageListeners.apply(pkg.body)
    @wsConnection.onclose = (event) =>
      console.log("onclose: ", event)
      if @connectionState == ConnectionState.Connecting
        @connect()

  serializePackage: (mb) ->
    # pkg = new ActorMessages.MTPackage(@authId, @sessionId, mb)
    # new ActorMessages.MTPackageBox(@packageId++, pkg).encode()
    new ActorMessages.MTPackage(@authId, @sessionId, mb).encode()

  rpcRequest: (req, f) ->
    @enqueueRpcMessage(req, f)

  requestAuthCode: (phoneNumber, f) ->
    @rpcRequest(new PM.RequestSendAuthCode(phoneNumber, 123, "test"), f) # TODO

  requestSignUp: (phoneNumber, smsHash, smsCode, name, publicKey, f) ->
    @rpcRequest(new PM.RequestSignUp(phoneNumber, smsHash, smsCode, name, publicKey, @deviceHash, @deviceTitle, @appId, @appKey, false), f)

  requestSignIn: (phoneNumber, smsHash, smsCode, publicKey, f) ->
    @rpcRequest(new PM.RequestSignIn(phoneNumber, smsHash, smsCode, publicKey), f)

  requestImportContacts: (phones, f) ->
    @rpcRequest(new PM.RequestImportContacts(phones, []), f)

  requestGetContacts: (hash, f) ->
    @rpcRequest(new PM.RequestGetContacts(hash), f)

  requestPublicKeys: (keys, f) ->
    @rpcRequest(new PM.RequestPublicKeys(keys), f)

  requestSendMessage: (uid, accessHash, randomId, message, f) ->
    @rpcRequest(new PM.RequestSendMessage(uid, accessHash, randomId, message), f)

  close: () ->
    clearInterval(@heartbeatInterval)
    @connectionState = ConnectionState.Closing

  rsaEncrypt: (message, publicKey) ->
    # RSA/ECB/OAEPWithSHA1AndMGF1Padding
    encrypted = publicKey.encrypt(message, 'RSA-OAEP', {
      md: forge.md.sha1.create(),
      mgf1: { md: forge.md.sha1.create() }
    })
    forge.util.encode64(encrypted)

  encryptAESKeys: (message, keys) ->
    _.map keys, (item) =>
      pk = pki.publicKeyFromAsn1(forge.asn1.fromDer(forge.util.decode64(item.key)))
      new ActorMessages.EncryptedAESKey(item.keyHash, @rsaEncrypt(message, pk))

  buildTextMessage: (text, randomId) ->
    message = new messageProto.TextMessage(text, text).encodeAB()
    decMsg = new messageProto.DecryptedMessage(randomId, @MessageType.TEXT, message).encodeAB()
    crcBuf = new ByteBuffer(8 + decMsg.byteLength) # sizeOf(DataType) + sizeOf(MessageType)
    lenBuf = new ByteBuffer(4)
    crcBuf.writeUint32(@MessageVersion)
    crcBuf.writeUint32(@DataType.DECRYPTED)
    crcBuf.append(decMsg)
    crcBuf.flip()
    crc32 = CRC32.bstr(crcBuf.toBinary())
    decData = new messageProto.DecryptedData(@MessageVersion, @DataType.DECRYPTED, decMsg, crc32).encode()
    lenBuf.writeUint32(decData.limit)
    lenBuf.flip()
    decData.prepend(lenBuf)
    decData.buffer

  encryptMessage: (message, senderKeys, receiverKeys) ->
    randomId = nextLong()
    aesKey = forge.random.getBytesSync(32)
    aesIv = forge.random.getBytesSync(16)
    aesFullKey = aesKey.concat(aesIv)
    encMessage = api.aesEncrypt(api.buildTextMessage(plainText, randomId), aesKey, aesIv)
    ownKeys = _.map senderKeys, (item) =>
      new ActorMessages.EncryptedAESKey(item.hash, @rsaEncrypt(aesFullKey, item.key))
    new ActorMessages.EncryptedRSAMessage(encMessage, userKeys, ownKeys)

  aesEncrypt: (message, aesKey, aesIv) ->
    cipher = forge.cipher.createCipher('AES-CBC', aesKey)
    cipher.start({ iv: aesIv })
    cipher.update(forge.util.createBuffer(message))
    cipher.finish()
    forge.util.encode64(cipher.output.getBytes())

  publicKeyHash: (key) ->
    md = forge.md.sha256.create()
    arr = []
    md.update(key)
    buf = md.digest().bytes()
    for i in [1..7]
      arr.push(buf.charCodeAt(i) ^ buf.charCodeAt(i + 8) ^ buf.charCodeAt(i + 16) ^ buf.charCodeAt(i + 24))
    low = ((arr[4] & 0xff) << 24) + ((arr[5] & 0xff) << 16) + ((arr[6] & 0xff) << 8) + (arr[7] & 0xff)
    high = ((arr[0] & 0xff) << 24) + ((arr[1] & 0xff) << 16) + ((arr[2] & 0xff) << 8) + (arr[3] & 0xff)
    new Long(low, high).toString()

  genKeyPair: (bits = 1024) ->
    rsa.generateKeyPair({ bits: bits, e: 0x10001 })

  requestGetDifference: (seq, state, f) ->
    @rpcRequest(new PM.RequestGetDifference(seq, state), f)

class SecretClient

