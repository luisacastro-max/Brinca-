import 'package:app_twins/services/core/backend_endpoints.dart';
import 'package:app_twins/services/core/service_exception.dart';
import 'package:app_twins/services/core/service_http_client.dart';

class ActivitiesApi {
  ActivitiesApi(this._httpClient);

  final ServiceHttpClient _httpClient;

  Future<List<Map<String, dynamic>>> getActivities() async {
    final response = await _httpClient.get(
      BackendEndpoints.activities,
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

  Future<List<Map<String, dynamic>>> getActivitiesByIds(
    List<String> activityIds,
  ) async {
    if (activityIds.isEmpty) return [];

    final response = await _httpClient.post(
      BackendEndpoints.activitiesByIds,
      requiresAuth: true,
      body: {'ids': activityIds},
    );

    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    return [];
  }

  Future<Map<String, dynamic>> getActivityById(String activityId) async {
    final response = await _httpClient.get(
      BackendEndpoints.activityById(activityId),
    );

    if (response is Map<String, dynamic>) return response;

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao buscar atividade.',
    );
  }

  Future<Map<String, dynamic>> getRecommendedActivities(String childId) async {
    final response = await _httpClient.get(
      BackendEndpoints.activitiesRecommended(childId),
      requiresAuth: true,
    );

    if (response is Map<String, dynamic>) return response;

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao buscar recomendacoes.',
    );
  }

  Future<Map<String, dynamic>> createActivity(
    Map<String, dynamic> payload,
  ) async {
    final response = await _httpClient.post(
      BackendEndpoints.activities,
      requiresAuth: true,
      body: payload,
    );

    if (response is Map<String, dynamic>) return response;

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao criar atividade.',
    );
  }

  Future<Map<String, dynamic>> updateActivity({
    required String activityId,
    required Map<String, dynamic> payload,
  }) async {
    final response = await _httpClient.put(
      BackendEndpoints.activityById(activityId),
      requiresAuth: true,
      body: payload,
    );

    if (response is Map<String, dynamic>) return response;

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao atualizar atividade.',
    );
  }

  Future<void> deleteActivity(String activityId) async {
    await _httpClient.delete(
      BackendEndpoints.activityById(activityId),
      requiresAuth: true,
    );
  }
}
