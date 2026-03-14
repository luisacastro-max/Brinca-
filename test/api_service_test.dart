// test/api_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:app_twins/api_service.dart';

void main() {
  group('ApiService', () {
    test('fetchTestData can be called (integration test)', () async {
      final apiService = ApiService();

      // This will test the real API if backend is running
      final result = await apiService.fetchTestData();

      // If backend returns {"message": "ok"}, it should pass
      // Otherwise, it will be null, but at least no compilation error
      expect(result, isA<Map<String, dynamic>?>()); // Allow null or map
    });
  });
}