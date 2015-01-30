'use strict';

var test = angular.module('test', []),
    Long = dcodeIO.Long,
    ByteBuffer = dcodeIO.ByteBuffer,
    rsa = forge.pki.rsa,
    pki = forge.pki,
    PM = ProtobufActorMessages;

String.prototype.getBytes = function() {
  var res = [];
  for (var i = 0; i < this.length; i++) {
    res.push(this.charCodeAt(i) & 0xff)
  }
  return res;
};

test.controller('WSController', ['$scope', function($scope) {
  var api;
  $scope.authId = localStorage.getItem("authId");
  $scope.sessionId = nextLong();
  if ($scope.authId) {
    api = new SecretAPI($scope.authId, $scope.sessionId);
  } else {
    api = SecretAPI.requestAuthId(function (err, api) {
      console.log("Got authId: " + api.getAuthId());
      $scope.$apply(function () {
        $scope.authId = api.getAuthId();
        localStorage.setItem("authId", $scope.authId);
      });
    });
  }

  var updatesDiv = document.getElementById("updates");
  api.addUpdateListener(function (err, update) {
     if (update) {
       updatesDiv.appendChild(document.createElement("<div>"+ JSON.stringify(update) + "</div>"));
     }
  });

  $scope.smsCode = "3333";
  $scope.phoneNumber = "75553867011";

  function loadKeys() {
    $scope.publicKeyBase64 = localStorage.getItem("publicKey");
    $scope.privateKeyBase64 = localStorage.getItem("privateKey");
    if ($scope.publicKeyBase64 && $scope.privateKeyBase64) {
      var rawPubKey = forge.util.decode64($scope.publicKeyBase64);
      $scope.publicKeyBytes = rawPubKey;
      $scope.publicKeyHash = api.publicKeyHash(rawPubKey);
      $scope.publicKey = pki.publicKeyFromAsn1(forge.asn1.fromDer(rawPubKey));
      $scope.privateKey = pki.privateKeyFromAsn1(forge.asn1.fromDer(forge.util.decode64($scope.privateKeyBase64)));
      console.log("publicKeyHash:", $scope.publicKeyHash);
    }
  }
  loadKeys();

  $scope.genKeys = function() {
    var keypair = api.genKeyPair();
    $scope.publicKey = keypair.publicKey;
    $scope.privateKey = keypair.privateKey;
    $scope.publicKeyBytes = forge.asn1.toDer(pki.publicKeyToAsn1($scope.publicKey)).getBytes();
    localStorage.setItem("publicKey", forge.util.encode64($scope.publicKeyBytes));
    localStorage.setItem("privateKey", forge.util.encode64(forge.asn1.toDer(pki.privateKeyToAsn1($scope.privateKey)).getBytes()));
    loadKeys();
  };

  $scope.usersPublicKeys = getFromStorage("usersPublicKeys") || {};
  $scope.importPublicKeys = function (user) {
     var keys = [];
     user.keyHashes.forEach(function (hash){
       console.log("parseLong(user.accessHash), parseLong(hash):", parseLong(user.accessHash).toString(), parseLong(hash).toString());
       keys.push(new PM.PublicKeyRequest(user.id, parseLong(user.accessHash), parseLong(hash)));
     });
     console.log("keys:",keys);
     console.log("importPublicKeys for ", user);
     api.requestPublicKeys(keys, function (err, res) {
       console.log("rpc requestPublicKeys: ", res, ", err: ", err);
       $scope.$apply(function () {
         console.log("import user: ", user);
         $scope.usersPublicKeys[user.uid] = res.keys;
         store("usersPublicKeys", $scope.usersPublicKeys);
         user.canSendMessage = true;
         store("importedContacts", $scope.importedContacts);
       });
     });
  };

  function getFromStorage(key) {
    var res = localStorage.getItem(key);
    if (res) return JSON.parse(res);
  }

  function store(key, obj) {
    localStorage.setItem(key, JSON.stringify(obj))
  }

  $scope.user = getFromStorage("user");
  $scope.userName = "Timothy (JS test #" + nextInt() + ")";
  $scope.signIn = function () {
    api.requestSignUp($scope.phoneNumber, $scope.smsHash, $scope.smsCode, $scope.userName, $scope.publicKeyBase64, function (err, res) {
      if (res) {
        store('user', res.user);
        $scope.$apply(function () {
          $scope.user = res.user;
        })
      }
      console.log("rpc sign up res: ", res, ", err: ", err);
    })
  };

  $scope.smsHash = null;
  $scope.getSmsCode = function () {
    // Request sms code
    api.requestAuthCode($scope.phoneNumber, function (err, res) {
      console.log("rpc res: ", res, ", err: ", err);
      $scope.$apply(function () {
        $scope.smsHash = res.smsHash;
      });
    });
  };

  var phones = [
    new PM.PhoneToImport("79853867016"),
    new PM.PhoneToImport("79313421248"),
    new PM.PhoneToImport("79817796093"),
    new PM.PhoneToImport("79313526281"),
    new PM.PhoneToImport("79268805629"),
    new PM.PhoneToImport("75554444444"),
    new PM.PhoneToImport("75552212121")
  ];

  $scope.importedContacts = getFromStorage("importedContacts");
  $scope.importContacts = function () {
    api.requestImportContacts(phones, function (err, res) {
      if (res) {
        console.log("res", res);
        api.requestGetContacts("", function (err, res) {
          console.log("requestGetContacts", res);
          store("importedContacts", res.users);
          $scope.$apply(function () {
            $scope.importedContacts = res.users;
          })
        })
      }
      console.log("rpc import contacts: ", res, ", err: ", err);
    })
  };

  function nextLong() {
    return Long.fromString(forge.util.bytesToHex(forge.random.getBytesSync(8)), 16).toString();
  }

  function nextInt() {
    return Long.fromString(forge.util.bytesToHex(forge.random.getBytesSync(4)), 16).getLowBits();
  }

  $scope.sendMessage = function (user) {
    var plainText = 'test#' + nextInt(),
      aesKey = forge.random.getBytesSync(32),
      aesIv = forge.random.getBytesSync(16),
      aesFullKey = aesKey + aesIv,
      randomId = nextLong(),
      encMessage = api.aesEncrypt(api.buildTextMessage(plainText, randomId), aesKey, aesIv),
      ownKeys = [new ActorMessages.EncryptedAESKey($scope.publicKeyHash, api.rsaEncrypt(aesFullKey, $scope.publicKey))],
      encRSAMessage = new ActorMessages.EncryptedRSAMessage(encMessage, api.encryptAESKeys(aesFullKey, $scope.usersPublicKeys[user.uid]), ownKeys);

    console.log("encMessage: ", encMessage);
    console.log("plainText: '" + plainText + "', aesKey: " + forge.util.encode64(aesKey) + ", aesIv: " + forge.util.encode64(aesIv));
    console.log("encRSAMessage:", encRSAMessage.serialize());

    api.requestSendMessage(user.uid, user.accessHash, randomId, encRSAMessage, function (err, res) {
      if (res) {
      }
      console.log("rpc send message: ", res, ", err: ", err);
    });
  };
}]);
