import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyName = 'medical_encryption_key';

  static late Key _key;
  static late IV _iv;

  static Future<void> init() async {
    String? storedKey = await _storage.read(key: _keyName);
    if (storedKey == null) {
      final newKey = Key.fromSecureRandom(32);
      await _storage.write(key: _keyName, value: newKey.base64);
      _key = newKey;
    } else {
      _key = Key.fromBase64(storedKey);
    }
    _iv = IV.fromLength(16);
  }

  static String encryptData(String plainText) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decryptData(String encryptedBase64) {
    final encrypter = Encrypter(AES(_key));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedBase64), iv: _iv);
    return decrypted;
  }
}
