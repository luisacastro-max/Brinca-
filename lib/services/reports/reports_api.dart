import 'package:app_twins/services/core/backend_endpoints.dart';
import 'package:app_twins/services/core/service_http_client.dart';
import 'package:app_twins/services/reports/reports_models.dart';

class ReportsApi {
  ReportsApi(this._httpClient);

  final ServiceHttpClient _httpClient;

  Future<ReportDownloadResult> downloadParentReport({
    required String childId,
    String period = 'thisMonth',
    String? startDate,
    String? endDate,
  }) async {
    final query = <String, dynamic>{
      'childId': childId,
      'period': period,
      if (startDate != null && startDate.trim().isNotEmpty) 'startDate': startDate,
      if (endDate != null && endDate.trim().isNotEmpty) 'endDate': endDate,
    };

    final response = await _httpClient.getBytes(
      BackendEndpoints.reportsParent,
      requiresAuth: true,
      query: query,
    );

    return ReportDownloadResult(
      bytes: response.bytes,
      fileName: response.fileName ?? 'relatorio_pais.pdf',
      contentType: response.contentType,
    );
  }

  Future<ReportDownloadResult> downloadClinicReport({
    String period = 'thisMonth',
    String? startDate,
    String? endDate,
  }) async {
    final query = <String, dynamic>{
      'period': period,
      if (startDate != null && startDate.trim().isNotEmpty) 'startDate': startDate,
      if (endDate != null && endDate.trim().isNotEmpty) 'endDate': endDate,
    };

    final response = await _httpClient.getBytes(
      BackendEndpoints.reportsClinic,
      requiresAuth: true,
      query: query,
    );

    return ReportDownloadResult(
      bytes: response.bytes,
      fileName: response.fileName ?? 'relatorio_clinico.pdf',
      contentType: response.contentType,
    );
  }
}
