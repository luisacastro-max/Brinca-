import 'package:app_twins/services/core/backend_endpoints.dart';
import 'package:app_twins/services/core/service_http_client.dart';

class UsersApi {
  UsersApi(this._httpClient);

  final ServiceHttpClient _httpClient;

  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await _httpClient.get(BackendEndpoints.users);

    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    return [];
  }
}
