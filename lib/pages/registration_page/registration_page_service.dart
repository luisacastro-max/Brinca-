import 'package:app_twins/services/service.dart';

class RegistrationPageService {
  RegistrationPageService({AuthApi? authApi})
    : _authApi = authApi ?? ServiceSdk.instance.auth;

  final AuthApi _authApi;

  Future<void> submit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String userType,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty || userType.isEmpty) {
      throw const ServiceException(
        statusCode: 400,
        message: 'Preencha todos os campos obrigatorios.',
      );
    }

    if (password != confirmPassword) {
      throw const ServiceException(
        statusCode: 400,
        message: 'As senhas nao conferem.',
      );
    }

    await _authApi.register(
      name: name,
      email: email,
      password: password,
      userType: userType,
    );

    await _authApi.login(
      email: email,
      password: password,
    );
  }
}
