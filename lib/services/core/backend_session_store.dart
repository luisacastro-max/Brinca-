import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null || userJson.isEmpty) return null;

    try {
      return Map<String, dynamic>.from(jsonDecode(userJson) as Map);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await _secureStorage.delete(key: _tokenKey);
    await prefs.remove(_userKey);
  }
}
