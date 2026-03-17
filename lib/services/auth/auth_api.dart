import 'package:app_twins/services/auth/models/auth_models.dart';
import 'package:app_twins/services/core/backend_endpoints.dart';
import 'package:app_twins/services/core/service_exception.dart';
import 'package:app_twins/services/core/service_http_client.dart';

class AuthApi {
  AuthApi(this._httpClient);

  final ServiceHttpClient _httpClient;

  String _normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  String _normalizeName(String name) {
    return name.trim();
  }

  void _validateRegisterInput({
    required String name,
    required String email,
    required String password,
  }) {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      throw const ServiceException(
        statusCode: 400,
        message: 'Nome, email e senha sao obrigatorios.',
      );
    }
  }

  void _validateLoginInput({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      throw const ServiceException(
        statusCode: 400,
        message: 'Email e senha sao obrigatorios.',
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _validateRegisterInput(name: name, email: email, password: password);

    await _httpClient.post(
      BackendEndpoints.authRegister,
      body: {
        'name': _normalizeName(name),
        'email': _normalizeEmail(email),
        'password': password,
      },
    );
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    _validateLoginInput(email: email, password: password);

    final response = await _httpClient.post(
      BackendEndpoints.authLogin,
      body: {
        'email': _normalizeEmail(email),
        'password': password,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const ServiceException(
        statusCode: 500,
        message: 'Resposta invalida no login.',
      );
    }

    final session = AuthSession.fromJson(response);
    if (session.token.isEmpty) {
      throw const ServiceException(
        statusCode: 500,
        message: 'Token nao retornado pelo backend.',
      );
    }

    await _httpClient.saveSession(
      token: session.token,
      user: session.user.toJson(),
    );

    return session;
  }

  Future<bool> isAuthenticated() {
    return _httpClient.isAuthenticated();
  }

  Future<BackendUser?> getCurrentUser() async {
    final json = await _httpClient.getCurrentUser();
    if (json == null) return null;
    return BackendUser.fromJson(json);
  }

  Future<void> logout() {
    return _httpClient.clearSession();
  }
}
