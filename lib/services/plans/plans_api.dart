import 'package:app_twins/services/core/backend_endpoints.dart';
import 'package:app_twins/services/core/service_exception.dart';
import 'package:app_twins/services/core/service_http_client.dart';

class PlansApi {
  PlansApi(this._httpClient);

  final ServiceHttpClient _httpClient;

  Future<List<Map<String, dynamic>>> getPlans() async {
    final response = await _httpClient.get(
      BackendEndpoints.plans,
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

  Future<Map<String, dynamic>> createPlan({
    required String childId,
    required DateTime weekStart,
    List<String> activities = const [],
  }) async {
    final response = await _httpClient.post(
      BackendEndpoints.plans,
      requiresAuth: true,
      body: {
        'child': childId,
        'weekStart': weekStart.toIso8601String(),
        'activities': activities,
      },
    );

    if (response is Map<String, dynamic>) return response;

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao criar plano.',
    );
  }

  Future<Map<String, dynamic>> updatePlan({
    required String planId,
    required Map<String, dynamic> payload,
  }) async {
    final response = await _httpClient.put(
      BackendEndpoints.planById(planId),
      requiresAuth: true,
      body: payload,
    );

    if (response is Map<String, dynamic>) return response;

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao atualizar plano.',
    );
  }
}
