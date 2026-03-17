import 'package:app_twins/services/activities/activities_api.dart';
import 'package:app_twins/services/auth/auth_api.dart';
import 'package:app_twins/services/children/children_api.dart';
import 'package:app_twins/services/core/service_http_client.dart';
import 'package:app_twins/services/plans/plans_api.dart';
import 'package:app_twins/services/users/users_api.dart';

class ServiceSdk {
  ServiceSdk._internal({ServiceHttpClient? httpClient})
    : _httpClient = httpClient ?? ServiceHttpClient() {
    auth = AuthApi(_httpClient);
    users = UsersApi(_httpClient);
    children = ChildrenApi(_httpClient);
    activities = ActivitiesApi(_httpClient);
    plans = PlansApi(_httpClient);
  }

  static final ServiceSdk instance = ServiceSdk._internal();

  final ServiceHttpClient _httpClient;

  late final AuthApi auth;
  late final UsersApi users;
  late final ChildrenApi children;
  late final ActivitiesApi activities;
  late final PlansApi plans;

  Future<Map<String, dynamic>?> ping() async {
    final response = await _httpClient.get('/ping');

    if (response is Map<String, dynamic>) return response;
    if (response is String) return {'message': response};
    return null;
  }
}
