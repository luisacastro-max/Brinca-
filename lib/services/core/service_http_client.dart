import 'dart:async';
import 'dart:convert';

import 'package:app_twins/api_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'service_exception.dart';
import 'backend_session_store.dart';

class ServiceHttpClient {
  ServiceHttpClient({
    http.Client? client,
    BackendSessionStore? sessionStore,
  })  : _client = client ?? http.Client(),
        _sessionStore = sessionStore ?? BackendSessionStore.instance;

  final http.Client _client;
  final BackendSessionStore _sessionStore;

  Future<bool> isAuthenticated() async {
    final token = await _sessionStore.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    await _sessionStore.saveToken(token);
    await _sessionStore.saveUser(user);
  }

  Future<Map<String, dynamic>?> getCurrentUser() {
    return _sessionStore.getUser();
  }

  Future<void> clearSession() {
    return _sessionStore.clear();
  }

  Future<dynamic> get(
    String path, {
    bool requiresAuth = false,
    Map<String, dynamic>? query,
  }) {
    return _request(
      'GET',
      path,
      requiresAuth: requiresAuth,
      query: query,
    );
  }

  Future<dynamic> post(
    String path, {
    bool requiresAuth = false,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return _request(
      'POST',
      path,
      requiresAuth: requiresAuth,
      body: body,
      query: query,
    );
  }

  Future<dynamic> put(
    String path, {
    bool requiresAuth = false,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return _request(
      'PUT',
      path,
      requiresAuth: requiresAuth,
      body: body,
      query: query,
    );
  }

  Future<dynamic> delete(
    String path, {
    bool requiresAuth = false,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return _request(
      'DELETE',
      path,
      requiresAuth: requiresAuth,
      body: body,
      query: query,
    );
  }

  Future<dynamic> patch(
    String path, {
    bool requiresAuth = false,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) {
    return _request(
      'PATCH',
      path,
      requiresAuth: requiresAuth,
      body: body,
      query: query,
    );
  }

  Future<dynamic> _request(
    String method,
    String path, {
    required bool requiresAuth,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) async {
    final token = await _sessionStore.getToken();
    if (requiresAuth && (token == null || token.isEmpty)) {
      throw const ServiceException(
        statusCode: 401,
        message: 'Sessao nao autenticada para esta operacao.',
      );
    }

    final uri = _buildUri(path, query: query);
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (requiresAuth) 'Authorization': 'Bearer $token',
    };

    http.Response response;
    final encodedBody = body == null ? null : jsonEncode(body);

    try {
      switch (method) {
        case 'GET':
          response = await _client
              .get(uri, headers: headers)
              .timeout(const Duration(seconds: 20));
          break;
        case 'POST':
          response = await _client
              .post(uri, headers: headers, body: encodedBody)
              .timeout(const Duration(seconds: 20));
          break;
        case 'PUT':
          response = await _client
              .put(uri, headers: headers, body: encodedBody)
              .timeout(const Duration(seconds: 20));
          break;
        case 'PATCH':
          response = await _client
              .patch(uri, headers: headers, body: encodedBody)
              .timeout(const Duration(seconds: 20));
          break;
        case 'DELETE':
          response = await _client
              .delete(uri, headers: headers, body: encodedBody)
              .timeout(const Duration(seconds: 20));
          break;
        default:
          throw ServiceException(
            statusCode: 500,
            message: 'Metodo HTTP nao suportado: $method',
          );
      }
    } on TimeoutException {
      throw const ServiceException(
        statusCode: 408,
        message: 'Tempo de requisicao esgotado.',
      );
    } catch (e) {
      throw ServiceException(
        statusCode: 0,
        message: 'Falha de conexao com o servidor.',
        details: kDebugMode ? e.toString() : null,
      );
    }

    final parsedBody = _parseBody(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return parsedBody;
    }

    if (response.statusCode == 401) {
      await _sessionStore.clear();
    }

    throw ServiceException(
      statusCode: response.statusCode,
      message: _extractErrorMessage(parsedBody, response.statusCode),
      details: kDebugMode ? parsedBody : null,
    );
  }

  Uri _buildUri(String path, {Map<String, dynamic>? query}) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final baseUri = Uri.parse('${ApiConfig.baseUrl}$normalizedPath');

    if (query == null || query.isEmpty) return baseUri;

    return baseUri.replace(
      queryParameters: query.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  dynamic _parseBody(String responseBody) {
    final body = responseBody.trim();
    if (body.isEmpty) return null;

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String _extractErrorMessage(dynamic parsedBody, int statusCode) {
    if (parsedBody is Map<String, dynamic>) {
      final message = parsedBody['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    if (parsedBody is String && parsedBody.trim().isNotEmpty) {
      return parsedBody;
    }

    return 'Erro HTTP $statusCode';
  }
}
