

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  static Future<void> writeToken(String key,String token) async {
    await _storage.write(key: key, value: token);
  }


  static Future<String?> readToken(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }
}