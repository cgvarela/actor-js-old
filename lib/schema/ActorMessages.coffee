# Automatically generated at Fri Jan 30 13:41:00 ICT 2015


class ServiceExtension
  @encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    int8.encode(msg.constructor.header, buf)
    bytes.encode(msg.encode(), buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    header = int8.decode(buf).value
    bodyBytes = bytes.decode(buf).value
    child = [ServiceExUserAdded,ServiceExUserKicked,ServiceExUserLeft,ServiceExGroupCreated,ServiceExChangedTitle,ServiceExChangedAvatar,ServiceExEmailContactRegistered]
    for klass in child
      return klass.decode(bodyBytes) if header == klass.header
    throw new Error("Unknown message header: #{header}")

    
class UpdateBoxMessage
  @encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    int32.encode(msg.constructor.header, buf)
    bytes.encode(msg.encode(), buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    header = int32.decode(buf).value
    bodyBytes = bytes.decode(buf).value
    child = [SeqUpdate,FatSeqUpdate,WeakUpdate,SeqUpdateTooLong]
    for klass in child
      return klass.decode(bodyBytes) if header == klass.header
    throw new Error("Unknown message header: #{header}")

    
class RpcResponseMessage
  @encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    int32.encode(msg.constructor.header, buf)
    bytes.encode(msg.encode(), buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    header = int32.decode(buf).value
    bodyBytes = bytes.decode(buf).value
    child = [ResponseAuth,ResponseVoid,ResponseSeq,ResponseSeqDate,ResponseSendAuthCode,ResponseGetAuthSessions,ResponseEditAvatar,ResponseImportContacts,ResponseGetContacts,ResponseSearchContacts,ResponseCreateGroup,ResponseEditGroupAvatar,ResponseLoadHistory,ResponseLoadDialogs,ResponseGetPublicKeys,ResponseGetFile,ResponseStartUpload,ResponseCompleteUpload,ResponseGetDifference]
    for klass in child
      return klass.decode(bodyBytes) if header == klass.header
    throw new Error("Unknown message header: #{header}")

    
class UpdateMessage
  @encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    int8.encode(msg.constructor.header, buf)
    bytes.encode(msg.encode(), buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    header = int8.decode(buf).value
    bodyBytes = bytes.decode(buf).value
    child = [UpdateUserAvatarChanged,UpdateUserNameChanged,UpdateUserLocalNameChanged,UpdateUserPhoneAdded,UpdateUserPhoneRemoved,UpdatePhoneTitleChanged,UpdatePhoneMoved,UpdateUserEmailAdded,UpdateUserEmailRemoved,UpdateEmailTitleChanged,UpdateEmailMoved,UpdateUserContactsChanged,UpdateUserStateChanged,UpdateContactRegistered,UpdateEmailContactRegistered,UpdateContactsAdded,UpdateContactsRemoved,UpdateEncryptedMessage,UpdateMessage,UpdateMessageSent,UpdateEncryptedReceived,UpdateEncryptedRead,UpdateEncryptedReadByMe,UpdateMessageReceived,UpdateMessageRead,UpdateMessageReadByMe,UpdateMessageDelete,UpdateChatClear,UpdateChatDelete,UpdateGroupInvite,UpdateGroupUserAdded,UpdateGroupUserLeave,UpdateGroupUserKick,UpdateGroupMembersUpdate,UpdateGroupTitleChanged,UpdateGroupAvatarChanged,UpdateNewDevice,UpdateRemovedDevice,UpdateTyping,UpdateUserOnline,UpdateUserOffline,UpdateUserLastSeen,UpdateGroupOnline,UpdateConfig]
    for klass in child
      return klass.decode(bodyBytes) if header == klass.header
    throw new Error("Unknown message header: #{header}")

    
class FileExtension
  @encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    int8.encode(msg.constructor.header, buf)
    bytes.encode(msg.encode(), buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    header = int8.decode(buf).value
    bodyBytes = bytes.decode(buf).value
    child = [FileExPhoto,FileExVideo,FileExVoice]
    for klass in child
      return klass.decode(bodyBytes) if header == klass.header
    throw new Error("Unknown message header: #{header}")

    
class RpcRequestMessage
  @encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    int32.encode(msg.constructor.header, buf)
    bytes.encode(msg.encode(), buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    header = int32.decode(buf).value
    bodyBytes = bytes.decode(buf).value
    child = [RequestSendAuthCode,RequestSendAuthCall,RequestSignIn,RequestSignUp,RequestGetAuthSessions,RequestTerminateSession,RequestTerminateAllSessions,RequestSignOut,RequestEditUserLocalName,RequestEditName,RequestEditAvatar,RequestRemoveAvatar,RequestSendEmailCode,RequestDetachEmail,RequestChangePhoneTitle,RequestChangeEmailTitle,RequestImportContacts,RequestGetContacts,RequestRemoveContact,RequestAddContact,RequestSearchContacts,RequestSendEncryptedMessage,RequestSendMessage,RequestEncryptedReceived,RequestEncryptedRead,RequestMessageReceived,RequestMessageRead,RequestDeleteMessage,RequestClearChat,RequestDeleteChat,RequestCreateGroup,RequestEditGroupTitle,RequestEditGroupAvatar,RequestRemoveGroupAvatar,RequestInviteUser,RequestLeaveGroup,RequestKickUser,RequestLoadHistory,RequestLoadDialogs,RequestGetPublicKeys,RequestTyping,RequestSetOnline,RequestGetFile,RequestStartUpload,RequestUploadPart,RequestCompleteUpload,RequestRegisterGooglePush,RequestRegisterApplePush,RequestUnregisterPush,RequestGetState,RequestGetDifference,RequestSubscribeToOnline,RequestSubscribeFromOnline,RequestSubscribeToGroupOnline,RequestSubscribeFromGroupOnline]
    for klass in child
      return klass.decode(bodyBytes) if header == klass.header
    throw new Error("Unknown message header: #{header}")

    
class Message
  @encode: (msg, buf) ->
    buf = ByteBuffer.alloc(buf)
    int8.encode(msg.constructor.header, buf)
    bytes.encode(msg.encode(), buf)
    buf.flipChain()
    buf

  @decode: (buf) ->
    header = int8.decode(buf).value
    bodyBytes = bytes.decode(buf).value
    child = [TextMessage,ServiceMessage,FileMessage]
    for klass in child
      return klass.decode(bodyBytes) if header == klass.header
    throw new Error("Unknown message header: #{header}")

    
class Sex
  @Unknown: 1
  @Male: 2
  @Female: 3

  @schema: ['Unknown','Male','Female']

        
class UserState
  @Registered: 1
  @Email: 2
  @Deleted: 3

  @schema: ['Registered','Email','Deleted']

        
class MessageState
  @Sent: 1
  @Received: 2
  @Read: 3

  @schema: ['Sent','Received','Read']

        
class PeerType
  @Private: 1
  @Group: 2
  @Email: 3

  @schema: ['Private','Group','Email']

        
class RequestSendAuthCode extends RpcRequestMessage
  @header: 0x1

  @schema:
    phoneNumber: { n: 1, type: "int64", rule: "required" }
    appId: { n: 2, type: "int32", rule: "required" }
    apiKey: { n: 3, type: "string", rule: "required" }

  constructor: (@phoneNumber, @appId, @apiKey) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSendAuthCode", bodyBytes)

    
class RequestSendAuthCall extends RpcRequestMessage
  @header: 0x5a

  @schema:
    phoneNumber: { n: 1, type: "int64", rule: "required" }
    smsHash: { n: 2, type: "string", rule: "required" }
    appId: { n: 3, type: "int32", rule: "required" }
    apiKey: { n: 4, type: "string", rule: "required" }

  constructor: (@phoneNumber, @smsHash, @appId, @apiKey) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSendAuthCall", bodyBytes)

    
class RequestSignIn extends RpcRequestMessage
  @header: 0x3

  @schema:
    phoneNumber: { n: 1, type: "int64", rule: "required" }
    smsHash: { n: 2, type: "string", rule: "required" }
    smsCode: { n: 3, type: "string", rule: "required" }
    publicKey: { n: 4, type: "bytes", rule: "required" }
    deviceHash: { n: 5, type: "bytes", rule: "required" }
    deviceTitle: { n: 6, type: "string", rule: "required" }
    appId: { n: 7, type: "int32", rule: "required" }
    appKey: { n: 8, type: "string", rule: "required" }

  constructor: (@phoneNumber, @smsHash, @smsCode, @publicKey, @deviceHash, @deviceTitle, @appId, @appKey) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSignIn", bodyBytes)

    
class RequestSignUp extends RpcRequestMessage
  @header: 0x4

  @schema:
    phoneNumber: { n: 1, type: "int64", rule: "required" }
    smsHash: { n: 2, type: "string", rule: "required" }
    smsCode: { n: 3, type: "string", rule: "required" }
    name: { n: 4, type: "string", rule: "required" }
    publicKey: { n: 6, type: "bytes", rule: "required" }
    deviceHash: { n: 7, type: "bytes", rule: "required" }
    deviceTitle: { n: 8, type: "string", rule: "required" }
    appId: { n: 9, type: "int32", rule: "required" }
    appKey: { n: 10, type: "string", rule: "required" }
    isSilent: { n: 11, type: "bool", rule: "required" }

  constructor: (@phoneNumber, @smsHash, @smsCode, @name, @publicKey, @deviceHash, @deviceTitle, @appId, @appKey, @isSilent) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSignUp", bodyBytes)

    
class RequestGetAuthSessions extends RpcRequestMessage
  @header: 0x50

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestGetAuthSessions", bodyBytes)

    
class RequestTerminateSession extends RpcRequestMessage
  @header: 0x52

  @schema:
    id: { n: 1, type: "int32", rule: "required" }

  constructor: (@id) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestTerminateSession", bodyBytes)

    
class RequestTerminateAllSessions extends RpcRequestMessage
  @header: 0x53

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestTerminateAllSessions", bodyBytes)

    
class RequestSignOut extends RpcRequestMessage
  @header: 0x54

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSignOut", bodyBytes)

    
class RequestEditUserLocalName extends RpcRequestMessage
  @header: 0x60

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }
    name: { n: 3, type: "string", rule: "required" }

  constructor: (@uid, @accessHash, @name) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestEditUserLocalName", bodyBytes)

    
class RequestEditName extends RpcRequestMessage
  @header: 0x35

  @schema:
    name: { n: 1, type: "string", rule: "required" }

  constructor: (@name) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestEditName", bodyBytes)

    
class RequestEditAvatar extends RpcRequestMessage
  @header: 0x1f

  @schema:
    fileLocation: { n: 1, type: "FileLocation", rule: "required" }

  constructor: (@fileLocation) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestEditAvatar", bodyBytes)

    
class RequestRemoveAvatar extends RpcRequestMessage
  @header: 0x5b

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestRemoveAvatar", bodyBytes)

    
class RequestSendEmailCode extends RpcRequestMessage
  @header: 0x78

  @schema:
    email: { n: 1, type: "string", rule: "required" }
    description: { n: 2, type: "string", rule: "optional" }

  constructor: (@email, @description) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSendEmailCode", bodyBytes)

    
class RequestDetachEmail extends RpcRequestMessage
  @header: 0x7b

  @schema:
    email: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }

  constructor: (@email, @accessHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestDetachEmail", bodyBytes)

    
class RequestChangePhoneTitle extends RpcRequestMessage
  @header: 0x7c

  @schema:
    phoneId: { n: 1, type: "int32", rule: "required" }
    title: { n: 2, type: "string", rule: "required" }

  constructor: (@phoneId, @title) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestChangePhoneTitle", bodyBytes)

    
class RequestChangeEmailTitle extends RpcRequestMessage
  @header: 0x7d

  @schema:
    emailId: { n: 1, type: "int32", rule: "required" }
    title: { n: 2, type: "string", rule: "required" }

  constructor: (@emailId, @title) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestChangeEmailTitle", bodyBytes)

    
class RequestImportContacts extends RpcRequestMessage
  @header: 0x7

  @schema:
    phones: { n: 1, type: "PhoneToImport", rule: "repeated" }
    emails: { n: 2, type: "EmailToImport", rule: "repeated" }

  constructor: (@phones, @emails) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestImportContacts", bodyBytes)

    
class RequestGetContacts extends RpcRequestMessage
  @header: 0x57

  @schema:
    contactsHash: { n: 1, type: "string", rule: "required" }

  constructor: (@contactsHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestGetContacts", bodyBytes)

    
class RequestRemoveContact extends RpcRequestMessage
  @header: 0x59

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }

  constructor: (@uid, @accessHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestRemoveContact", bodyBytes)

    
class RequestAddContact extends RpcRequestMessage
  @header: 0x72

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }

  constructor: (@uid, @accessHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestAddContact", bodyBytes)

    
class RequestSearchContacts extends RpcRequestMessage
  @header: 0x70

  @schema:
    request: { n: 1, type: "string", rule: "required" }

  constructor: (@request) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSearchContacts", bodyBytes)

    
class RequestSendEncryptedMessage extends RpcRequestMessage
  @header: 0xe

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }
    rid: { n: 3, type: "int64", rule: "required" }
    encryptedMessage: { n: 4, type: "bytes", rule: "required" }
    keys: { n: 5, type: "EncryptedAesKey", rule: "repeated" }
    ownKeys: { n: 6, type: "EncryptedAesKey", rule: "repeated" }

  constructor: (@peer, @rid, @encryptedMessage, @keys, @ownKeys) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSendEncryptedMessage", bodyBytes)

    
class RequestSendMessage extends RpcRequestMessage
  @header: 0x5c

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }
    rid: { n: 3, type: "int64", rule: "required" }
    message: { n: 4, type: "MessageContent", rule: "required" }

  constructor: (@peer, @rid, @message) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSendMessage", bodyBytes)

    
class RequestEncryptedReceived extends RpcRequestMessage
  @header: 0x74

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }
    rid: { n: 3, type: "int64", rule: "required" }

  constructor: (@peer, @rid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestEncryptedReceived", bodyBytes)

    
class RequestEncryptedRead extends RpcRequestMessage
  @header: 0x75

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }
    rid: { n: 3, type: "int64", rule: "required" }

  constructor: (@peer, @rid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestEncryptedRead", bodyBytes)

    
class RequestMessageReceived extends RpcRequestMessage
  @header: 0x37

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }
    date: { n: 3, type: "int64", rule: "required" }

  constructor: (@peer, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestMessageReceived", bodyBytes)

    
class RequestMessageRead extends RpcRequestMessage
  @header: 0x39

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }
    date: { n: 3, type: "int64", rule: "required" }

  constructor: (@peer, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestMessageRead", bodyBytes)

    
class RequestDeleteMessage extends RpcRequestMessage
  @header: 0x62

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }
    rids: { n: 3, type: "int64", rule: "repeated" }

  constructor: (@peer, @rids) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestDeleteMessage", bodyBytes)

    
class RequestClearChat extends RpcRequestMessage
  @header: 0x63

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }

  constructor: (@peer) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestClearChat", bodyBytes)

    
class RequestDeleteChat extends RpcRequestMessage
  @header: 0x64

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }

  constructor: (@peer) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestDeleteChat", bodyBytes)

    
class RequestCreateGroup extends RpcRequestMessage
  @header: 0x41

  @schema:
    rid: { n: 1, type: "int64", rule: "required" }
    title: { n: 2, type: "string", rule: "required" }
    users: { n: 3, type: "UserOutPeer", rule: "repeated" }

  constructor: (@rid, @title, @users) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestCreateGroup", bodyBytes)

    
class RequestEditGroupTitle extends RpcRequestMessage
  @header: 0x55

  @schema:
    groupPeer: { n: 1, type: "GroupOutPeer", rule: "required" }
    rid: { n: 4, type: "int64", rule: "required" }
    title: { n: 3, type: "string", rule: "required" }

  constructor: (@groupPeer, @rid, @title) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestEditGroupTitle", bodyBytes)

    
class RequestEditGroupAvatar extends RpcRequestMessage
  @header: 0x56

  @schema:
    groupPeer: { n: 1, type: "GroupOutPeer", rule: "required" }
    rid: { n: 4, type: "int64", rule: "required" }
    fileLocation: { n: 3, type: "FileLocation", rule: "required" }

  constructor: (@groupPeer, @rid, @fileLocation) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestEditGroupAvatar", bodyBytes)

    
class RequestRemoveGroupAvatar extends RpcRequestMessage
  @header: 0x65

  @schema:
    groupPeer: { n: 1, type: "GroupOutPeer", rule: "required" }
    rid: { n: 4, type: "int64", rule: "required" }

  constructor: (@groupPeer, @rid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestRemoveGroupAvatar", bodyBytes)

    
class RequestInviteUser extends RpcRequestMessage
  @header: 0x45

  @schema:
    groupPeer: { n: 1, type: "GroupOutPeer", rule: "required" }
    rid: { n: 4, type: "int64", rule: "required" }
    user: { n: 3, type: "UserOutPeer", rule: "required" }

  constructor: (@groupPeer, @rid, @user) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestInviteUser", bodyBytes)

    
class RequestLeaveGroup extends RpcRequestMessage
  @header: 0x46

  @schema:
    groupPeer: { n: 1, type: "GroupOutPeer", rule: "required" }
    rid: { n: 2, type: "int64", rule: "required" }

  constructor: (@groupPeer, @rid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestLeaveGroup", bodyBytes)

    
class RequestKickUser extends RpcRequestMessage
  @header: 0x47

  @schema:
    groupPeer: { n: 1, type: "GroupOutPeer", rule: "required" }
    rid: { n: 4, type: "int64", rule: "required" }
    user: { n: 3, type: "UserOutPeer", rule: "required" }

  constructor: (@groupPeer, @rid, @user) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestKickUser", bodyBytes)

    
class RequestLoadHistory extends RpcRequestMessage
  @header: 0x76

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }
    startDate: { n: 3, type: "int64", rule: "required" }
    limit: { n: 4, type: "int32", rule: "required" }

  constructor: (@peer, @startDate, @limit) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestLoadHistory", bodyBytes)

    
class RequestLoadDialogs extends RpcRequestMessage
  @header: 0x68

  @schema:
    startDate: { n: 1, type: "int64", rule: "required" }
    limit: { n: 2, type: "int32", rule: "required" }

  constructor: (@startDate, @limit) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestLoadDialogs", bodyBytes)

    
class RequestGetPublicKeys extends RpcRequestMessage
  @header: 0x6

  @schema:
    keys: { n: 1, type: "PublicKeyRequest", rule: "repeated" }

  constructor: (@keys) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestGetPublicKeys", bodyBytes)

    
class RequestTyping extends RpcRequestMessage
  @header: 0x1b

  @schema:
    peer: { n: 1, type: "OutPeer", rule: "required" }
    typingType: { n: 3, type: "int32", rule: "required" }

  constructor: (@peer, @typingType) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestTyping", bodyBytes)

    
class RequestSetOnline extends RpcRequestMessage
  @header: 0x1d

  @schema:
    isOnline: { n: 1, type: "bool", rule: "required" }
    timeout: { n: 2, type: "int64", rule: "required" }

  constructor: (@isOnline, @timeout) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSetOnline", bodyBytes)

    
class RequestGetFile extends RpcRequestMessage
  @header: 0x10

  @schema:
    fileLocation: { n: 1, type: "FileLocation", rule: "required" }
    offset: { n: 2, type: "int32", rule: "required" }
    limit: { n: 3, type: "int32", rule: "required" }

  constructor: (@fileLocation, @offset, @limit) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestGetFile", bodyBytes)

    
class RequestStartUpload extends RpcRequestMessage
  @header: 0x12

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestStartUpload", bodyBytes)

    
class RequestUploadPart extends RpcRequestMessage
  @header: 0x14

  @schema:
    config: { n: 1, type: "UploadConfig", rule: "required" }
    blockIndex: { n: 2, type: "int32", rule: "required" }
    payload: { n: 3, type: "bytes", rule: "required" }

  constructor: (@config, @blockIndex, @payload) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestUploadPart", bodyBytes)

    
class RequestCompleteUpload extends RpcRequestMessage
  @header: 0x16

  @schema:
    config: { n: 1, type: "UploadConfig", rule: "required" }
    blocksCount: { n: 2, type: "int32", rule: "required" }
    crc32: { n: 3, type: "int64", rule: "required" }

  constructor: (@config, @blocksCount, @crc32) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestCompleteUpload", bodyBytes)

    
class RequestRegisterGooglePush extends RpcRequestMessage
  @header: 0x33

  @schema:
    projectId: { n: 1, type: "int64", rule: "required" }
    token: { n: 2, type: "string", rule: "required" }

  constructor: (@projectId, @token) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestRegisterGooglePush", bodyBytes)

    
class RequestRegisterApplePush extends RpcRequestMessage
  @header: 0x4c

  @schema:
    apnsKey: { n: 1, type: "int32", rule: "required" }
    token: { n: 2, type: "string", rule: "required" }

  constructor: (@apnsKey, @token) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestRegisterApplePush", bodyBytes)

    
class RequestUnregisterPush extends RpcRequestMessage
  @header: 0x34

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestUnregisterPush", bodyBytes)

    
class RequestGetState extends RpcRequestMessage
  @header: 0x9

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestGetState", bodyBytes)

    
class RequestGetDifference extends RpcRequestMessage
  @header: 0xb

  @schema:
    seq: { n: 1, type: "int32", rule: "required" }
    state: { n: 2, type: "bytes", rule: "required" }

  constructor: (@seq, @state) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestGetDifference", bodyBytes)

    
class RequestSubscribeToOnline extends RpcRequestMessage
  @header: 0x20

  @schema:
    users: { n: 1, type: "UserOutPeer", rule: "repeated" }

  constructor: (@users) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSubscribeToOnline", bodyBytes)

    
class RequestSubscribeFromOnline extends RpcRequestMessage
  @header: 0x21

  @schema:
    users: { n: 1, type: "UserOutPeer", rule: "repeated" }

  constructor: (@users) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSubscribeFromOnline", bodyBytes)

    
class RequestSubscribeToGroupOnline extends RpcRequestMessage
  @header: 0x4a

  @schema:
    groups: { n: 1, type: "GroupOutPeer", rule: "repeated" }

  constructor: (@groups) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSubscribeToGroupOnline", bodyBytes)

    
class RequestSubscribeFromGroupOnline extends RpcRequestMessage
  @header: 0x4b

  @schema:
    groups: { n: 1, type: "GroupOutPeer", rule: "repeated" }

  constructor: (@groups) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("RequestSubscribeFromGroupOnline", bodyBytes)

    
class ResponseAuth extends RpcResponseMessage
  @header: 0x5

  @schema:
    publicKeyHash: { n: 1, type: "int64", rule: "required" }
    user: { n: 2, type: "User", rule: "required" }
    config: { n: 3, type: "Config", rule: "required" }

  constructor: (@publicKeyHash, @user, @config) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseAuth", bodyBytes)

    
class ResponseVoid extends RpcResponseMessage
  @header: 0x32

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseVoid", bodyBytes)

    
class ResponseSeq extends RpcResponseMessage
  @header: 0x48

  @schema:
    seq: { n: 1, type: "int32", rule: "required" }
    state: { n: 2, type: "bytes", rule: "required" }

  constructor: (@seq, @state) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseSeq", bodyBytes)

    
class ResponseSeqDate extends RpcResponseMessage
  @header: 0x66

  @schema:
    seq: { n: 1, type: "int32", rule: "required" }
    state: { n: 2, type: "bytes", rule: "required" }
    date: { n: 3, type: "int64", rule: "required" }

  constructor: (@seq, @state, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseSeqDate", bodyBytes)

    
class ResponseSendAuthCode extends RpcResponseMessage
  @header: 0x2

  @schema:
    smsHash: { n: 1, type: "string", rule: "required" }
    isRegistered: { n: 2, type: "bool", rule: "required" }

  constructor: (@smsHash, @isRegistered) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseSendAuthCode", bodyBytes)

    
class ResponseGetAuthSessions extends RpcResponseMessage
  @header: 0x51

  @schema:
    userAuths: { n: 1, type: "AuthSession", rule: "repeated" }

  constructor: (@userAuths) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseGetAuthSessions", bodyBytes)

    
class ResponseEditAvatar extends RpcResponseMessage
  @header: 0x67

  @schema:
    avatar: { n: 1, type: "Avatar", rule: "required" }
    seq: { n: 2, type: "int32", rule: "required" }
    state: { n: 3, type: "bytes", rule: "required" }

  constructor: (@avatar, @seq, @state) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseEditAvatar", bodyBytes)

    
class ResponseImportContacts extends RpcResponseMessage
  @header: 0x8

  @schema:
    users: { n: 1, type: "User", rule: "repeated" }
    seq: { n: 2, type: "int32", rule: "required" }
    state: { n: 3, type: "bytes", rule: "required" }

  constructor: (@users, @seq, @state) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseImportContacts", bodyBytes)

    
class ResponseGetContacts extends RpcResponseMessage
  @header: 0x58

  @schema:
    users: { n: 1, type: "User", rule: "repeated" }
    isNotChanged: { n: 2, type: "bool", rule: "required" }

  constructor: (@users, @isNotChanged) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseGetContacts", bodyBytes)

    
class ResponseSearchContacts extends RpcResponseMessage
  @header: 0x71

  @schema:
    users: { n: 1, type: "User", rule: "repeated" }

  constructor: (@users) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseSearchContacts", bodyBytes)

    
class ResponseCreateGroup extends RpcResponseMessage
  @header: 0x42

  @schema:
    groupPeer: { n: 1, type: "GroupOutPeer", rule: "required" }
    seq: { n: 3, type: "int32", rule: "required" }
    state: { n: 4, type: "bytes", rule: "required" }
    users: { n: 5, type: "int32", rule: "repeated" }
    date: { n: 6, type: "int64", rule: "required" }

  constructor: (@groupPeer, @seq, @state, @users, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseCreateGroup", bodyBytes)

    
class ResponseEditGroupAvatar extends RpcResponseMessage
  @header: 0x73

  @schema:
    avatar: { n: 1, type: "Avatar", rule: "required" }
    seq: { n: 2, type: "int32", rule: "required" }
    state: { n: 3, type: "bytes", rule: "required" }
    date: { n: 4, type: "int64", rule: "required" }

  constructor: (@avatar, @seq, @state, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseEditGroupAvatar", bodyBytes)

    
class ResponseLoadHistory extends RpcResponseMessage
  @header: 0x77

  @schema:
    history: { n: 1, type: "HistoryMessage", rule: "repeated" }
    users: { n: 2, type: "User", rule: "repeated" }

  constructor: (@history, @users) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseLoadHistory", bodyBytes)

    
class ResponseLoadDialogs extends RpcResponseMessage
  @header: 0x69

  @schema:
    groups: { n: 1, type: "Group", rule: "repeated" }
    users: { n: 2, type: "User", rule: "repeated" }
    dialogs: { n: 3, type: "Dialog", rule: "repeated" }

  constructor: (@groups, @users, @dialogs) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseLoadDialogs", bodyBytes)

    
class ResponseGetPublicKeys extends RpcResponseMessage
  @header: 0x18

  @schema:
    keys: { n: 1, type: "PublicKey", rule: "repeated" }

  constructor: (@keys) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseGetPublicKeys", bodyBytes)

    
class ResponseGetFile extends RpcResponseMessage
  @header: 0x11

  @schema:
    payload: { n: 1, type: "bytes", rule: "required" }

  constructor: (@payload) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseGetFile", bodyBytes)

    
class ResponseStartUpload extends RpcResponseMessage
  @header: 0x13

  @schema:
    config: { n: 1, type: "UploadConfig", rule: "required" }

  constructor: (@config) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseStartUpload", bodyBytes)

    
class ResponseCompleteUpload extends RpcResponseMessage
  @header: 0x17

  @schema:
    location: { n: 1, type: "FileLocation", rule: "required" }

  constructor: (@location) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseCompleteUpload", bodyBytes)

    
class ResponseGetDifference extends RpcResponseMessage
  @header: 0xc

  @schema:
    seq: { n: 1, type: "int32", rule: "required" }
    state: { n: 2, type: "bytes", rule: "required" }
    users: { n: 3, type: "User", rule: "repeated" }
    groups: { n: 6, type: "Group", rule: "repeated" }
    phones: { n: 7, type: "Phone", rule: "repeated" }
    emails: { n: 8, type: "Email", rule: "repeated" }
    updates: { n: 4, type: "DifferenceUpdate", rule: "repeated" }
    needMore: { n: 5, type: "bool", rule: "required" }

  constructor: (@seq, @state, @users, @groups, @phones, @emails, @updates, @needMore) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ResponseGetDifference", bodyBytes)

    
class SeqUpdate extends UpdateBoxMessage
  @header: 0xd

  @schema:
    seq: { n: 1, type: "int32", rule: "required" }
    state: { n: 2, type: "bytes", rule: "required" }
    updateHeader: { n: 3, type: "int32", rule: "required" }
    update: { n: 4, type: "bytes", rule: "required" }

  constructor: (@seq, @state, @update) ->
    @updateHeader = update.constructor.header

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("SeqUpdate", bodyBytes)

    
class FatSeqUpdate extends UpdateBoxMessage
  @header: 0x49

  @schema:
    seq: { n: 1, type: "int32", rule: "required" }
    state: { n: 2, type: "bytes", rule: "required" }
    updateHeader: { n: 3, type: "int32", rule: "required" }
    update: { n: 4, type: "bytes", rule: "required" }
    users: { n: 5, type: "User", rule: "repeated" }
    groups: { n: 6, type: "Group", rule: "repeated" }
    phones: { n: 7, type: "Phone", rule: "repeated" }
    emails: { n: 8, type: "Email", rule: "repeated" }

  constructor: (@seq, @state, @update, @users, @groups, @phones, @emails) ->
    @updateHeader = update.constructor.header

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("FatSeqUpdate", bodyBytes)

    
class WeakUpdate extends UpdateBoxMessage
  @header: 0x1a

  @schema:
    date: { n: 1, type: "int64", rule: "required" }
    updateHeader: { n: 2, type: "int32", rule: "required" }
    update: { n: 3, type: "bytes", rule: "required" }

  constructor: (@date, @update) ->
    @updateHeader = update.constructor.header

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("WeakUpdate", bodyBytes)

    
class SeqUpdateTooLong extends UpdateBoxMessage
  @header: 0x19

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("SeqUpdateTooLong", bodyBytes)

    
class UpdateUserAvatarChanged extends UpdateMessage
  @header: 0x10

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    avatar: { n: 2, type: "Avatar", rule: "optional" }

  constructor: (@uid, @avatar) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserAvatarChanged", bodyBytes)

    
class UpdateUserNameChanged extends UpdateMessage
  @header: 0x20

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    name: { n: 2, type: "string", rule: "required" }

  constructor: (@uid, @name) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserNameChanged", bodyBytes)

    
class UpdateUserLocalNameChanged extends UpdateMessage
  @header: 0x33

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    localName: { n: 2, type: "string", rule: "optional" }

  constructor: (@uid, @localName) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserLocalNameChanged", bodyBytes)

    
class UpdateUserPhoneAdded extends UpdateMessage
  @header: 0x57

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    phoneId: { n: 2, type: "int32", rule: "required" }

  constructor: (@uid, @phoneId) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserPhoneAdded", bodyBytes)

    
class UpdateUserPhoneRemoved extends UpdateMessage
  @header: 0x58

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    phoneId: { n: 2, type: "int32", rule: "required" }

  constructor: (@uid, @phoneId) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserPhoneRemoved", bodyBytes)

    
class UpdatePhoneTitleChanged extends UpdateMessage
  @header: 0x59

  @schema:
    phoneId: { n: 2, type: "int32", rule: "required" }
    title: { n: 3, type: "string", rule: "required" }

  constructor: (@phoneId, @title) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdatePhoneTitleChanged", bodyBytes)

    
class UpdatePhoneMoved extends UpdateMessage
  @header: 0x65

  @schema:
    phoneId: { n: 1, type: "int32", rule: "required" }
    uid: { n: 2, type: "int32", rule: "required" }

  constructor: (@phoneId, @uid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdatePhoneMoved", bodyBytes)

    
class UpdateUserEmailAdded extends UpdateMessage
  @header: 0x60

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    emailId: { n: 2, type: "int32", rule: "required" }

  constructor: (@uid, @emailId) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserEmailAdded", bodyBytes)

    
class UpdateUserEmailRemoved extends UpdateMessage
  @header: 0x61

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    emailId: { n: 2, type: "int32", rule: "required" }

  constructor: (@uid, @emailId) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserEmailRemoved", bodyBytes)

    
class UpdateEmailTitleChanged extends UpdateMessage
  @header: 0x62

  @schema:
    emailId: { n: 1, type: "int32", rule: "required" }
    title: { n: 2, type: "string", rule: "required" }

  constructor: (@emailId, @title) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateEmailTitleChanged", bodyBytes)

    
class UpdateEmailMoved extends UpdateMessage
  @header: 0x66

  @schema:
    emailId: { n: 1, type: "int32", rule: "required" }
    uid: { n: 2, type: "int32", rule: "required" }

  constructor: (@emailId, @uid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateEmailMoved", bodyBytes)

    
class UpdateUserContactsChanged extends UpdateMessage
  @header: 0x56

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    phones: { n: 2, type: "int32", rule: "repeated" }
    emails: { n: 3, type: "int32", rule: "repeated" }

  constructor: (@uid, @phones, @emails) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserContactsChanged", bodyBytes)

    
class UpdateUserStateChanged extends UpdateMessage
  @header: 0x64

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    state: { n: 2, type: "UserState", rule: "required" }

  constructor: (@uid, @state) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserStateChanged", bodyBytes)

    
class UpdateContactRegistered extends UpdateMessage
  @header: 0x5

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    isSilent: { n: 2, type: "bool", rule: "required" }
    date: { n: 3, type: "int64", rule: "required" }

  constructor: (@uid, @isSilent, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateContactRegistered", bodyBytes)

    
class UpdateEmailContactRegistered extends UpdateMessage
  @header: 0x78

  @schema:
    emailId: { n: 1, type: "int32", rule: "required" }
    uid: { n: 2, type: "int32", rule: "required" }

  constructor: (@emailId, @uid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateEmailContactRegistered", bodyBytes)

    
class UpdateContactsAdded extends UpdateMessage
  @header: 0x28

  @schema:
    uids: { n: 1, type: "int32", rule: "repeated" }

  constructor: (@uids) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateContactsAdded", bodyBytes)

    
class UpdateContactsRemoved extends UpdateMessage
  @header: 0x29

  @schema:
    uids: { n: 1, type: "int32", rule: "repeated" }

  constructor: (@uids) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateContactsRemoved", bodyBytes)

    
class UpdateEncryptedMessage extends UpdateMessage
  @header: 0x1

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    senderUid: { n: 2, type: "int32", rule: "required" }
    date: { n: 6, type: "int64", rule: "required" }
    keyHash: { n: 3, type: "int64", rule: "required" }
    aesEncryptedKey: { n: 4, type: "bytes", rule: "required" }
    message: { n: 5, type: "bytes", rule: "required" }

  constructor: (@peer, @senderUid, @date, @keyHash, @aesEncryptedKey, @message) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateEncryptedMessage", bodyBytes)

    
class UpdateMessage extends UpdateMessage
  @header: 0x37

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    senderUid: { n: 2, type: "int32", rule: "required" }
    date: { n: 3, type: "int64", rule: "required" }
    rid: { n: 4, type: "int64", rule: "required" }
    message: { n: 5, type: "MessageContent", rule: "required" }

  constructor: (@peer, @senderUid, @date, @rid, @message) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateMessage", bodyBytes)

    
class UpdateMessageSent extends UpdateMessage
  @header: 0x4

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    rid: { n: 2, type: "int64", rule: "required" }
    date: { n: 3, type: "int64", rule: "required" }

  constructor: (@peer, @rid, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateMessageSent", bodyBytes)

    
class UpdateEncryptedReceived extends UpdateMessage
  @header: 0x12

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    rid: { n: 2, type: "int64", rule: "required" }
    receivedDate: { n: 3, type: "int64", rule: "required" }

  constructor: (@peer, @rid, @receivedDate) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateEncryptedReceived", bodyBytes)

    
class UpdateEncryptedRead extends UpdateMessage
  @header: 0x34

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    rid: { n: 2, type: "int64", rule: "required" }
    readDate: { n: 3, type: "int64", rule: "required" }

  constructor: (@peer, @rid, @readDate) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateEncryptedRead", bodyBytes)

    
class UpdateEncryptedReadByMe extends UpdateMessage
  @header: 0x35

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    rid: { n: 2, type: "int64", rule: "required" }

  constructor: (@peer, @rid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateEncryptedReadByMe", bodyBytes)

    
class UpdateMessageReceived extends UpdateMessage
  @header: 0x36

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    startDate: { n: 2, type: "int64", rule: "required" }
    receivedDate: { n: 3, type: "int64", rule: "required" }

  constructor: (@peer, @startDate, @receivedDate) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateMessageReceived", bodyBytes)

    
class UpdateMessageRead extends UpdateMessage
  @header: 0x13

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    startDate: { n: 2, type: "int64", rule: "required" }
    readDate: { n: 3, type: "int64", rule: "required" }

  constructor: (@peer, @startDate, @readDate) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateMessageRead", bodyBytes)

    
class UpdateMessageReadByMe extends UpdateMessage
  @header: 0x32

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    startDate: { n: 2, type: "int64", rule: "required" }

  constructor: (@peer, @startDate) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateMessageReadByMe", bodyBytes)

    
class UpdateMessageDelete extends UpdateMessage
  @header: 0x2e

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    rids: { n: 2, type: "int64", rule: "repeated" }

  constructor: (@peer, @rids) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateMessageDelete", bodyBytes)

    
class UpdateChatClear extends UpdateMessage
  @header: 0x2f

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }

  constructor: (@peer) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateChatClear", bodyBytes)

    
class UpdateChatDelete extends UpdateMessage
  @header: 0x30

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }

  constructor: (@peer) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateChatDelete", bodyBytes)

    
class UpdateGroupInvite extends UpdateMessage
  @header: 0x24

  @schema:
    groupId: { n: 1, type: "int32", rule: "required" }
    rid: { n: 9, type: "int64", rule: "required" }
    inviteUid: { n: 5, type: "int32", rule: "required" }
    date: { n: 8, type: "int64", rule: "required" }

  constructor: (@groupId, @rid, @inviteUid, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateGroupInvite", bodyBytes)

    
class UpdateGroupUserAdded extends UpdateMessage
  @header: 0x15

  @schema:
    groupId: { n: 1, type: "int32", rule: "required" }
    rid: { n: 5, type: "int64", rule: "required" }
    uid: { n: 2, type: "int32", rule: "required" }
    inviterUid: { n: 3, type: "int32", rule: "required" }
    date: { n: 4, type: "int64", rule: "required" }

  constructor: (@groupId, @rid, @uid, @inviterUid, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateGroupUserAdded", bodyBytes)

    
class UpdateGroupUserLeave extends UpdateMessage
  @header: 0x17

  @schema:
    groupId: { n: 1, type: "int32", rule: "required" }
    rid: { n: 4, type: "int64", rule: "required" }
    uid: { n: 2, type: "int32", rule: "required" }
    date: { n: 3, type: "int64", rule: "required" }

  constructor: (@groupId, @rid, @uid, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateGroupUserLeave", bodyBytes)

    
class UpdateGroupUserKick extends UpdateMessage
  @header: 0x18

  @schema:
    groupId: { n: 1, type: "int32", rule: "required" }
    rid: { n: 5, type: "int64", rule: "required" }
    uid: { n: 2, type: "int32", rule: "required" }
    kickerUid: { n: 3, type: "int32", rule: "required" }
    date: { n: 4, type: "int64", rule: "required" }

  constructor: (@groupId, @rid, @uid, @kickerUid, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateGroupUserKick", bodyBytes)

    
class UpdateGroupMembersUpdate extends UpdateMessage
  @header: 0x2c

  @schema:
    groupId: { n: 1, type: "int32", rule: "required" }
    members: { n: 2, type: "Member", rule: "repeated" }

  constructor: (@groupId, @members) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateGroupMembersUpdate", bodyBytes)

    
class UpdateGroupTitleChanged extends UpdateMessage
  @header: 0x26

  @schema:
    groupId: { n: 1, type: "int32", rule: "required" }
    rid: { n: 5, type: "int64", rule: "required" }
    uid: { n: 2, type: "int32", rule: "required" }
    title: { n: 3, type: "string", rule: "required" }
    date: { n: 4, type: "int64", rule: "required" }

  constructor: (@groupId, @rid, @uid, @title, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateGroupTitleChanged", bodyBytes)

    
class UpdateGroupAvatarChanged extends UpdateMessage
  @header: 0x27

  @schema:
    groupId: { n: 1, type: "int32", rule: "required" }
    rid: { n: 5, type: "int64", rule: "required" }
    uid: { n: 2, type: "int32", rule: "required" }
    avatar: { n: 3, type: "Avatar", rule: "optional" }
    date: { n: 4, type: "int64", rule: "required" }

  constructor: (@groupId, @rid, @uid, @avatar, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateGroupAvatarChanged", bodyBytes)

    
class UpdateNewDevice extends UpdateMessage
  @header: 0x2

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    keyHash: { n: 2, type: "int64", rule: "required" }
    key: { n: 3, type: "bytes", rule: "optional" }
    date: { n: 4, type: "int64", rule: "required" }

  constructor: (@uid, @keyHash, @key, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateNewDevice", bodyBytes)

    
class UpdateRemovedDevice extends UpdateMessage
  @header: 0x25

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    keyHash: { n: 2, type: "int64", rule: "required" }

  constructor: (@uid, @keyHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateRemovedDevice", bodyBytes)

    
class UpdateTyping extends UpdateMessage
  @header: 0x6

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    uid: { n: 2, type: "int32", rule: "required" }
    typingType: { n: 3, type: "int32", rule: "required" }

  constructor: (@peer, @uid, @typingType) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateTyping", bodyBytes)

    
class UpdateUserOnline extends UpdateMessage
  @header: 0x7

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }

  constructor: (@uid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserOnline", bodyBytes)

    
class UpdateUserOffline extends UpdateMessage
  @header: 0x8

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }

  constructor: (@uid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserOffline", bodyBytes)

    
class UpdateUserLastSeen extends UpdateMessage
  @header: 0x9

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    date: { n: 2, type: "int64", rule: "required" }

  constructor: (@uid, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateUserLastSeen", bodyBytes)

    
class UpdateGroupOnline extends UpdateMessage
  @header: 0x21

  @schema:
    groupId: { n: 1, type: "int32", rule: "required" }
    count: { n: 2, type: "int32", rule: "required" }

  constructor: (@groupId, @count) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateGroupOnline", bodyBytes)

    
class UpdateConfig extends UpdateMessage
  @header: 0x2a

  @schema:
    config: { n: 1, type: "Config", rule: "required" }

  constructor: (@config) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UpdateConfig", bodyBytes)

    
class AuthSession

  @schema:
    id: { n: 1, type: "int32", rule: "required" }
    authHolder: { n: 2, type: "int32", rule: "required" }
    appId: { n: 3, type: "int32", rule: "required" }
    appTitle: { n: 4, type: "string", rule: "required" }
    deviceTitle: { n: 5, type: "string", rule: "required" }
    authTime: { n: 6, type: "int32", rule: "required" }
    authLocation: { n: 7, type: "string", rule: "required" }
    latitude: { n: 8, type: "double", rule: "optional" }
    longitude: { n: 9, type: "double", rule: "optional" }

  constructor: (@id, @authHolder, @appId, @appTitle, @deviceTitle, @authTime, @authLocation, @latitude, @longitude) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("AuthSession", bodyBytes)

    
class Phone

  @schema:
    id: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }
    phone: { n: 3, type: "int64", rule: "required" }
    phoneTitle: { n: 4, type: "string", rule: "required" }

  constructor: (@id, @accessHash, @phone, @phoneTitle) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("Phone", bodyBytes)

    
class Email

  @schema:
    id: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }
    email: { n: 3, type: "string", rule: "required" }
    emailTitle: { n: 4, type: "string", rule: "required" }

  constructor: (@id, @accessHash, @email, @emailTitle) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("Email", bodyBytes)

    
class User

  @schema:
    id: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }
    name: { n: 3, type: "string", rule: "required" }
    localName: { n: 4, type: "string", rule: "optional" }
    sex: { n: 5, type: "Sex", rule: "optional" }
    keyHashes: { n: 6, type: "int64", rule: "repeated" }
    phone: { n: 7, type: "int64", rule: "required" }
    avatar: { n: 8, type: "Avatar", rule: "optional" }
    phones: { n: 9, type: "int32", rule: "repeated" }
    emails: { n: 10, type: "int32", rule: "repeated" }
    userState: { n: 11, type: "UserState", rule: "required" }

  constructor: (@id, @accessHash, @name, @localName, @sex, @keyHashes, @phone, @avatar, @phones, @emails, @userState) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("User", bodyBytes)

    
class PhoneToImport

  @schema:
    phoneNumber: { n: 1, type: "int64", rule: "required" }
    name: { n: 2, type: "string", rule: "optional" }

  constructor: (@phoneNumber, @name) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("PhoneToImport", bodyBytes)

    
class EmailToImport

  @schema:
    email: { n: 1, type: "string", rule: "required" }
    name: { n: 2, type: "string", rule: "optional" }

  constructor: (@email, @name) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("EmailToImport", bodyBytes)

    
class MessageContent

  @schema:
    type: { n: 1, type: "int32", rule: "required" }
    content: { n: 2, type: "Message", rule: "required" }

  constructor: (@content) ->
    @type = content.constructor.header

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("MessageContent", bodyBytes)

    
class TextMessage extends Message

  @schema:
    text: { n: 1, type: "string", rule: "required" }
    extType: { n: 2, type: "int32", rule: "required" }
    ext: { n: 3, type: "bytes", rule: "optional" }

  constructor: (@text, @extType, @ext) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("TextMessage", bodyBytes)

    
class ServiceMessage extends Message

  @schema:
    text: { n: 1, type: "string", rule: "required" }
    extType: { n: 2, type: "int32", rule: "required" }
    ext: { n: 3, type: "ServiceExtension", rule: "optional" }

  constructor: (@text, @ext) ->
    @extType = ext.constructor.header

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ServiceMessage", bodyBytes)

    
class ServiceExUserAdded extends ServiceExtension

  @schema:
    addedUid: { n: 1, type: "int32", rule: "required" }

  constructor: (@addedUid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ServiceExUserAdded", bodyBytes)

    
class ServiceExUserKicked extends ServiceExtension

  @schema:
    kickedUid: { n: 1, type: "int32", rule: "required" }

  constructor: (@kickedUid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ServiceExUserKicked", bodyBytes)

    
class ServiceExUserLeft extends ServiceExtension

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ServiceExUserLeft", bodyBytes)

    
class ServiceExGroupCreated extends ServiceExtension

  @schema:
    {}

  constructor: () ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ServiceExGroupCreated", bodyBytes)

    
class ServiceExChangedTitle extends ServiceExtension

  @schema:
    title: { n: 1, type: "string", rule: "required" }

  constructor: (@title) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ServiceExChangedTitle", bodyBytes)

    
class ServiceExChangedAvatar extends ServiceExtension

  @schema:
    avatar: { n: 1, type: "Avatar", rule: "optional" }

  constructor: (@avatar) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ServiceExChangedAvatar", bodyBytes)

    
class ServiceExEmailContactRegistered extends ServiceExtension

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }

  constructor: (@uid) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("ServiceExEmailContactRegistered", bodyBytes)

    
class FileMessage extends Message

  @schema:
    fileId: { n: 1, type: "int64", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }
    fileSize: { n: 3, type: "int32", rule: "required" }
    name: { n: 4, type: "string", rule: "required" }
    mimeType: { n: 5, type: "string", rule: "required" }
    thumb: { n: 6, type: "FastThumb", rule: "optional" }
    extType: { n: 7, type: "int32", rule: "required" }
    ext: { n: 8, type: "bytes", rule: "optional" }

  constructor: (@fileId, @accessHash, @fileSize, @name, @mimeType, @thumb, @extType, @ext) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("FileMessage", bodyBytes)

    
class FileExPhoto extends FileExtension

  @schema:
    w: { n: 1, type: "int32", rule: "required" }
    h: { n: 2, type: "int32", rule: "required" }

  constructor: (@w, @h) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("FileExPhoto", bodyBytes)

    
class FileExVideo extends FileExtension

  @schema:
    w: { n: 1, type: "int32", rule: "required" }
    h: { n: 2, type: "int32", rule: "required" }
    duration: { n: 3, type: "int32", rule: "required" }

  constructor: (@w, @h, @duration) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("FileExVideo", bodyBytes)

    
class FileExVoice extends FileExtension

  @schema:
    duration: { n: 1, type: "int32", rule: "required" }

  constructor: (@duration) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("FileExVoice", bodyBytes)

    
class WrongKeysErrorData

  @schema:
    newKeys: { n: 1, type: "UserKey", rule: "repeated" }
    removedKeys: { n: 2, type: "UserKey", rule: "repeated" }
    invalidKeys: { n: 3, type: "UserKey", rule: "repeated" }

  constructor: (@newKeys, @removedKeys, @invalidKeys) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("WrongKeysErrorData", bodyBytes)

    
class EncryptedAesKey

  @schema:
    keyHash: { n: 1, type: "int64", rule: "required" }
    aesEncryptedKey: { n: 2, type: "bytes", rule: "required" }

  constructor: (@keyHash, @aesEncryptedKey) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("EncryptedAesKey", bodyBytes)

    
class Group

  @schema:
    id: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }
    title: { n: 3, type: "string", rule: "required" }
    avatar: { n: 4, type: "Avatar", rule: "optional" }
    isMember: { n: 6, type: "bool", rule: "required" }
    adminUid: { n: 8, type: "int32", rule: "required" }
    members: { n: 9, type: "Member", rule: "repeated" }
    createDate: { n: 10, type: "int64", rule: "required" }

  constructor: (@id, @accessHash, @title, @avatar, @isMember, @adminUid, @members, @createDate) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("Group", bodyBytes)

    
class Member

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    inviterUid: { n: 2, type: "int32", rule: "required" }
    date: { n: 3, type: "int64", rule: "required" }

  constructor: (@uid, @inviterUid, @date) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("Member", bodyBytes)

    
class HistoryMessage

  @schema:
    senderUid: { n: 1, type: "int32", rule: "required" }
    rid: { n: 2, type: "int64", rule: "required" }
    date: { n: 3, type: "int64", rule: "required" }
    message: { n: 5, type: "MessageContent", rule: "required" }
    state: { n: 6, type: "MessageState", rule: "optional" }

  constructor: (@senderUid, @rid, @date, @message, @state) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("HistoryMessage", bodyBytes)

    
class Dialog

  @schema:
    peer: { n: 1, type: "Peer", rule: "required" }
    unreadCount: { n: 3, type: "int32", rule: "required" }
    sortDate: { n: 4, type: "int64", rule: "required" }
    senderUid: { n: 5, type: "int32", rule: "required" }
    rid: { n: 6, type: "int64", rule: "required" }
    date: { n: 7, type: "int64", rule: "required" }
    message: { n: 8, type: "MessageContent", rule: "required" }
    state: { n: 9, type: "MessageState", rule: "optional" }

  constructor: (@peer, @unreadCount, @sortDate, @senderUid, @rid, @date, @message, @state) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("Dialog", bodyBytes)

    
class UserKey

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    keyHash: { n: 2, type: "int64", rule: "required" }

  constructor: (@uid, @keyHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UserKey", bodyBytes)

    
class PublicKey

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    keyHash: { n: 2, type: "int64", rule: "required" }
    key: { n: 3, type: "bytes", rule: "required" }

  constructor: (@uid, @keyHash, @key) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("PublicKey", bodyBytes)

    
class PublicKeyRequest

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }
    keyHash: { n: 3, type: "int64", rule: "required" }

  constructor: (@uid, @accessHash, @keyHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("PublicKeyRequest", bodyBytes)

    
class FileLocation

  @schema:
    fileId: { n: 1, type: "int64", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }

  constructor: (@fileId, @accessHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("FileLocation", bodyBytes)

    
class AvatarImage

  @schema:
    fileLocation: { n: 1, type: "FileLocation", rule: "required" }
    width: { n: 2, type: "int32", rule: "required" }
    height: { n: 3, type: "int32", rule: "required" }
    fileSize: { n: 4, type: "int32", rule: "required" }

  constructor: (@fileLocation, @width, @height, @fileSize) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("AvatarImage", bodyBytes)

    
class Avatar

  @schema:
    smallImage: { n: 1, type: "AvatarImage", rule: "optional" }
    largeImage: { n: 2, type: "AvatarImage", rule: "optional" }
    fullImage: { n: 3, type: "AvatarImage", rule: "optional" }

  constructor: (@smallImage, @largeImage, @fullImage) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("Avatar", bodyBytes)

    
class FastThumb

  @schema:
    w: { n: 1, type: "int32", rule: "required" }
    h: { n: 2, type: "int32", rule: "required" }
    thumb: { n: 3, type: "bytes", rule: "required" }

  constructor: (@w, @h, @thumb) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("FastThumb", bodyBytes)

    
class UploadConfig

  @schema:
    serverData: { n: 1, type: "bytes", rule: "required" }

  constructor: (@serverData) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UploadConfig", bodyBytes)

    
class Peer

  @schema:
    type: { n: 1, type: "PeerType", rule: "required" }
    id: { n: 2, type: "int32", rule: "required" }

  constructor: (@type, @id) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("Peer", bodyBytes)

    
class OutPeer

  @schema:
    type: { n: 1, type: "PeerType", rule: "required" }
    id: { n: 2, type: "int32", rule: "required" }
    accessHash: { n: 3, type: "int64", rule: "required" }

  constructor: (@type, @id, @accessHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("OutPeer", bodyBytes)

    
class UserOutPeer

  @schema:
    uid: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }

  constructor: (@uid, @accessHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("UserOutPeer", bodyBytes)

    
class GroupOutPeer

  @schema:
    groupId: { n: 1, type: "int32", rule: "required" }
    accessHash: { n: 2, type: "int64", rule: "required" }

  constructor: (@groupId, @accessHash) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("GroupOutPeer", bodyBytes)

    
class DifferenceUpdate

  @schema:
    updateHeader: { n: 1, type: "int32", rule: "required" }
    update: { n: 2, type: "bytes", rule: "required" }

  constructor: (@update) ->
    @updateHeader = update.constructor.header

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("DifferenceUpdate", bodyBytes)

    
class Config

  @schema:
    maxGroupSize: { n: 1, type: "int32", rule: "required" }

  constructor: (@maxGroupSize) ->

  encode: () ->
    Protobuf.encode(@)

  @decode: (bodyBytes) ->
    Protobuf.decode("Config", bodyBytes)

    
window.ProtobufActorMessages = @
