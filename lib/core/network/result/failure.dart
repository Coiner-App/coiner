class Failure {
  final FailureType type;
  final String message;
  final int? statusCode;
  final String? errorCode;
  final bool retryable;

  Failure({
    this.type = FailureType.unknown,
    required this.message,
    this.statusCode,
    this.errorCode,
    this.retryable = false,
  });
}

enum FailureType {
  network,
  unauthorized,
  validation,
  server,
  unknown,
}