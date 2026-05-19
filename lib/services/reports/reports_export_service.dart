import 'package:app_twins/services/reports/reports_api.dart';
import 'package:app_twins/services/reports/reports_models.dart';
import 'package:app_twins/services/service_sdk.dart';
import 'package:file_saver/file_saver.dart';
import 'package:share_plus/share_plus.dart';

class ReportsExportService {
  ReportsExportService({ReportsApi? reportsApi})
      : _reportsApi = reportsApi ?? ServiceSdk.instance.reports;

  final ReportsApi _reportsApi;

  Future<ReportDownloadResult> fetchParentReport({
    required String childId,
    required String period,
    String? startDate,
    String? endDate,
  }) {
    return _reportsApi.downloadParentReport(
      childId: childId,
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<ReportDownloadResult> fetchClinicReport({
    required String period,
    String? startDate,
    String? endDate,
  }) {
    return _reportsApi.downloadClinicReport(
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> saveReport(ReportDownloadResult result) async {
    final fileName = result.fileName.trim().isEmpty
        ? 'relatorio.pdf'
        : result.fileName.trim();

    final dotIndex = fileName.lastIndexOf('.');
    final baseName = dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
    final extension = dotIndex > 0
        ? fileName.substring(dotIndex + 1).toLowerCase()
        : 'pdf';

    await FileSaver.instance.saveFile(
      name: baseName,
      bytes: result.bytes,
      fileExtension: extension,
      mimeType: MimeType.pdf,
    );
  }

  Future<void> shareReport(
    ReportDownloadResult result, {
    String? text,
  }) async {
    try {
      await Share.shareXFiles(
        [
          XFile.fromData(
            result.bytes,
            mimeType: result.contentType,
            name: result.fileName,
          ),
        ],
        text: text,
      );
    } catch (_) {
      await saveReport(result);
    }
  }
}
