import 'package:app_twins/services/core/backend_endpoints.dart';
import 'package:app_twins/services/core/service_exception.dart';
import 'package:app_twins/services/core/service_http_client.dart';

class CompletedActivitiesApi {
  CompletedActivitiesApi(this._httpClient);

  final ServiceHttpClient _httpClient;

  Future<List<String>> startActivity({
    required String activityId,
    required List<String> childIds,
  }) async {
    final response = await _httpClient.post(
      BackendEndpoints.completedActivitiesStart,
      requiresAuth: true,
      body: {
        'activityId': activityId,
        'childIds': childIds,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const ServiceException(
        statusCode: 500,
        message: 'Resposta invalida ao iniciar atividade.',
      );
    }

    final rawIds = response['completedActivityIds'];
    if (rawIds is! List) {
      throw const ServiceException(
        statusCode: 500,
        message: 'Resposta sem completedActivityIds.',
      );
    }

    return rawIds
      .map((id) => id.toString().trim())
      .where((id) => id.isNotEmpty)
      .toList();
  }

  Future<void> completeActivities({
    required List<String> completedActivityIds,
  }) async {
    await _httpClient.patch(
      BackendEndpoints.completedActivitiesComplete,
      requiresAuth: true,
      body: {
        'completedActivityIds': completedActivityIds,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getCompletedByChild(String childId) async {
    final response = await _httpClient.get(
      BackendEndpoints.completedActivitiesByChild(childId),
      requiresAuth: true,
    );

    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao buscar atividades concluidas.',
    );
  }
}
