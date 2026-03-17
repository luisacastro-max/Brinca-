import 'package:app_twins/services/core/backend_endpoints.dart';
import 'package:app_twins/services/core/service_exception.dart';
import 'package:app_twins/services/core/service_http_client.dart';

class ChildrenApi {
  ChildrenApi(this._httpClient);

  final ServiceHttpClient _httpClient;

  Future<Map<String, dynamic>> createChild({
    required String name,
    required String ageRange,
    required int dailyTime,
    List<String> interests = const [],
    List<String> developmentGoals = const [],
  }) async {
    final response = await _httpClient.post(
      BackendEndpoints.children,
      requiresAuth: true,
      body: {
        'name': name,
        'ageRange': ageRange,
        'dailyTime': dailyTime,
        'interests': interests,
        'developmentGoals': developmentGoals,
      },
    );

    if (response is Map<String, dynamic>) return response;

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao criar crianca.',
    );
  }

  Future<List<Map<String, dynamic>>> getChildren() async {
    final response = await _httpClient.get(
      BackendEndpoints.children,
      requiresAuth: true,
    );

    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    return [];
  }

  Future<Map<String, dynamic>> updateChild({
    required String childId,
    required Map<String, dynamic> payload,
  }) async {
    final response = await _httpClient.put(
      '${BackendEndpoints.children}/$childId',
      requiresAuth: true,
      body: payload,
    );

    if (response is Map<String, dynamic>) return response;

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao atualizar crianca.',
    );
  }

  Future<void> deleteChild(String childId) async {
    await _httpClient.delete(
      '${BackendEndpoints.children}/$childId',
      requiresAuth: true,
    );
  }
}
