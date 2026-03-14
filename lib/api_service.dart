// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>?> fetchTestData() async {
    try {
      final response = await client.get(Uri.parse('${ApiConfig.baseUrl}/test'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return null;
    }
  }
}
