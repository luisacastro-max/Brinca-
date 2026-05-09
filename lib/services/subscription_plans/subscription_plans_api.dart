import 'package:app_twins/services/core/backend_endpoints.dart';
import 'package:app_twins/services/core/service_exception.dart';
import 'package:app_twins/services/core/service_http_client.dart';

class SubscriptionPlansApi {
  SubscriptionPlansApi(this._httpClient);

  final ServiceHttpClient _httpClient;

  Future<List<Map<String, dynamic>>> getSubscriptionPlans() async {
    final response = await _httpClient.get(
      BackendEndpoints.subscriptionPlans,
      requiresAuth: true,
    );

    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    return const <Map<String, dynamic>>[];
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required String planId,
  }) async {
    final response = await _httpClient.post(
      BackendEndpoints.subscriptionPlanPaymentIntent(planId),
      requiresAuth: true,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw const ServiceException(
      statusCode: 500,
      message: 'Resposta invalida ao criar payment intent.',
    );
  }
}
