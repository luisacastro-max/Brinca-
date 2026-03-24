import 'package:app_twins/services/service.dart';

class LoginPageService {
  LoginPageService({AuthApi? authApi})
    : _authApi = authApi ?? ServiceSdk.instance.auth;

  final AuthApi _authApi;

  Future<void> submit({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw const ServiceException(
        statusCode: 400,
        message: 'Por favor, preencha todos os campos.',
      );
    }

    await _authApi.login(email: email, password: password);
  }
}
