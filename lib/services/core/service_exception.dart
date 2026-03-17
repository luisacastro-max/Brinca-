class ServiceException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;

  const ServiceException({
    required this.statusCode,
    required this.message,
    this.details,
  });

  @override
  String toString() {
    return 'ServiceException(statusCode: $statusCode, message: $message)';
  }
}
