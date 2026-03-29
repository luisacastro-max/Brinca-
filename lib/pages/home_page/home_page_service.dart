import 'package:app_twins/services/service.dart';

class HomePageViewData {
  const HomePageViewData({
    required this.userName,
    required this.userInitial,
    required this.planLabel,
    required this.completedActivitiesThisWeek,
  });

  final String userName;
  final String userInitial;
  final String planLabel;
  final int completedActivitiesThisWeek;
}

class HomePageService {
  HomePageService({AuthApi? authApi})
    : _authApi = authApi ?? ServiceSdk.instance.auth;

  final AuthApi _authApi;

  Future<bool> hasValidSession() async {
    final hasToken = await _authApi.isAuthenticated();
    if (!hasToken) return false;

    final user = await _authApi.getCurrentUser();
    return user != null && user.id.trim().isNotEmpty;
  }

  Future<HomePageViewData> loadData() async {
    final isValid = await hasValidSession();
    if (!isValid) {
      throw const ServiceException(
        statusCode: 401,
        message: 'Sessao invalida. Faca login novamente.',
      );
    }

    final currentUser = await _authApi.getCurrentUser();
    final name = (currentUser?.name ?? 'Usuario').trim();
    final userInitial = name.isEmpty ? 'U' : name.substring(0, 1).toUpperCase();

    return HomePageViewData(
      userName: name.isEmpty ? 'Usuario' : name,
      userInitial: userInitial,
      planLabel: 'Plano Gratuito',
      completedActivitiesThisWeek: 5,
    );
  }

  Future<void> logout() {
    return _authApi.logout();
  }
}
