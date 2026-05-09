import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BackendSessionStore {
  BackendSessionStore._();

  static final BackendSessionStore instance = BackendSessionStore._();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _tokenKey = 'backend_auth_token';
  static const String _userKey = 'backend_auth_user';

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: _tokenKey);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _secureStorage.write(key: _userKey, value: jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userJson = await _secureStorage.read(key: _userKey);
    if (userJson == null || userJson.isEmpty) return null;

    try {
      return Map<String, dynamic>.from(jsonDecode(userJson) as Map);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _userKey);
  }
}
