import 'package:app_twins/services/core/backend_endpoints.dart';
import 'package:app_twins/services/core/service_http_client.dart';

class UsersApi {
  UsersApi(this._httpClient);

  final ServiceHttpClient _httpClient;

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final response = await _httpClient.get(
      BackendEndpoints.usersMe,
      requiresAuth: true,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    return null;
  }
}
