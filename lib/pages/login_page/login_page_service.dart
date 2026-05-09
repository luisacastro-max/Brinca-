import 'package:app_twins/services/service.dart';

class LoginPageService {
  LoginPageService({AuthApi? authApi})
    : _authApi = authApi ?? ServiceSdk.instance.auth;

  final AuthApi _authApi;

  Future<BackendUser> submit({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw const ServiceException(
        statusCode: 400,
        message: 'Por favor, preencha todos os campos.',
      );
    }

    final session = await _authApi.login(
      email: email,
      password: password,
    );

    return session.user;
  }
}
