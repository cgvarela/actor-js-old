# Automatically generated at Fri Jan 30 13:41:00 ICT 2015


class EncryptionType
  @NONE: 0
  @AES: 1
  @AES_THEN_MAC: 2

  @schema: ['NONE','AES','AES_THEN_MAC']

        
class PlainPackage

  @schema:
    messsageType: { n: 1, type: "int32", rule: "required" }
    body: { n: 2, type: "bytes", rule: "required" }
    crc32: { n: 3, type: "int64", rule: "required" }

  constructor: (@messsageType, @body, @crc32) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("PlainPackage", bodyBytes)

    
class PlainMessage

  @schema:
    guid: { n: 1, type: "int64", rule: "required" }
    messageTyoe: { n: 2, type: "int32", rule: "required" }
    body: { n: 3, type: "bytes", rule: "required" }

  constructor: (@guid, @messageTyoe, @body) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("PlainMessage", bodyBytes)

    
class TextMessage

  @schema:
    text: { n: 1, type: "string", rule: "required" }
    extType: { n: 2, type: "int32", rule: "required" }
    extension: { n: 3, type: "bytes", rule: "optional" }

  constructor: (@text, @extType, @extension) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("TextMessage", bodyBytes)

    
class FileMessage

  @schema:
    name: { n: 1, type: "string", rule: "required" }
    mimeType: { n: 2, type: "string", rule: "required" }
    fileLocation: { n: 3, type: "PlainFileLocation", rule: "required" }
    fastThumb: { n: 4, type: "FastThumb", rule: "optional" }
    extType: { n: 5, type: "int32", rule: "required" }
    extension: { n: 6, type: "bytes", rule: "optional" }

  constructor: (@name, @mimeType, @fileLocation, @fastThumb, @extType, @extension) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("FileMessage", bodyBytes)

    
class PlainFileLocation

  @schema:
    fileId: { n: 1, type: "int64", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }
    fileSize: { n: 3, type: "int32", rule: "required" }
    encryptionType: { n: 4, type: "EncryptionType", rule: "required" }
    encryptedFileSize: { n: 5, type: "int32", rule: "required" }
    encryptionKey: { n: 6, type: "bytes", rule: "required" }

  constructor: (@fileId, @accessHash, @fileSize, @encryptionType, @encryptedFileSize, @encryptionKey) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("PlainFileLocation", bodyBytes)

    
class FastThumb

  @schema:
    w: { n: 1, type: "int32", rule: "required" }
    h: { n: 2, type: "int32", rule: "required" }
    preview: { n: 4, type: "bytes", rule: "required" }

  constructor: (@w, @h, @preview) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("FastThumb", bodyBytes)

    
class ServiceMessage

  @schema:
    text: { n: 1, type: "string", rule: "required" }
    extType: { n: 2, type: "int32", rule: "required" }
    extension: { n: 3, type: "bytes", rule: "optional" }

  constructor: (@text, @extType, @extension) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ServiceMessage", bodyBytes)

    
class MarkdownMessage

  @schema:
    markdown: { n: 1, type: "string", rule: "required" }

  constructor: (@markdown) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("MarkdownMessage", bodyBytes)

    
class PhotoExtension

  @schema:
    w: { n: 1, type: "int32", rule: "required" }
    h: { n: 2, type: "int32", rule: "required" }

  constructor: (@w, @h) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("PhotoExtension", bodyBytes)

    
class VideoExtension

  @schema:
    w: { n: 1, type: "int32", rule: "required" }
    h: { n: 2, type: "int32", rule: "required" }
    duration: { n: 3, type: "int32", rule: "required" }

  constructor: (@w, @h, @duration) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("VideoExtension", bodyBytes)

    
class AudioExtension

  @schema:
    duration: { n: 3, type: "int32", rule: "required" }

  constructor: (@duration) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("AudioExtension", bodyBytes)

    
window.ProtobufActorEncryptedMessages = @
