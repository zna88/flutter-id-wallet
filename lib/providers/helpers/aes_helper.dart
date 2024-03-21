import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

import 'package:flutter_id_wallet/models/models.dart';

class AESHelper {
  static const String _DEFAULT_APP_SECRET_KEY =
      'tH!sISr3a11YAwS0me@n3Wwa113tApP1';
  static const String _DEFAULT_SECRET_KEY = 'D3f@uLt53creTk3y2EnCRyptM0DuL300';

  static EncryptionInfo encrypt(
    String plainText, {
    EncryptionType encryptionType = EncryptionType.module,
    String secretKey = '',
  }) {
    final String secretKeyValue =
        secretKey == '' ? _getDefaultKey(encryptionType) : secretKey;
    final Key key = Key.fromSecureRandom(32);
    final IV iv = IV.fromSecureRandom(16);
    final mac = Uint8List.fromList(utf8.encode(secretKeyValue));
    final Encrypter encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    final Encrypted encrypted =
        encrypter.encrypt(plainText, iv: iv, associatedData: mac);
    return EncryptionInfo(
      encrypted: encrypted.base64,
      key: key.base64,
      iv: iv.base64,
    );
  }

  static String decrypt(
    EncryptionInfo encryptionInfo, {
    EncryptionType encryptionType = EncryptionType.module,
    String secretKey = '',
  }) {
    final String secretKeyValue =
        secretKey == '' ? _getDefaultKey(encryptionType) : secretKey;
    final Key key = Key.fromBase64(encryptionInfo.key);
    final IV iv = IV.fromBase64(encryptionInfo.iv);
    final mac = Uint8List.fromList(utf8.encode(secretKeyValue));
    final Encrypter encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    try {
      return encrypter.decrypt(Encrypted.fromBase64(encryptionInfo.encrypted),
          iv: iv, associatedData: mac);
    } catch (e) {
      print('Error at AESHelper.decrypt(): $e');
      return '';
    }
  }

  static String _getDefaultKey(EncryptionType encryptionType) {
    String _base64EncodedKey = _DEFAULT_SECRET_KEY;
    switch (encryptionType) {
      case EncryptionType.app:
        _base64EncodedKey = _DEFAULT_APP_SECRET_KEY;
        break;
      case EncryptionType.module:
        _base64EncodedKey = _DEFAULT_SECRET_KEY;
        break;
    }

    return _base64EncodedKey;
  }
}

enum EncryptionType {
  app,
  module,
}
