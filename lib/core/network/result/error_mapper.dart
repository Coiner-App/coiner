import 'package:dio/dio.dart';
import 'failure.dart';

Failure mapDioError(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.connectionError) {
    return Failure(
      type: FailureType.network,
      message: "No internet connection",
      retryable: true,
    );
  }

  final status = e.response?.statusCode;
  final String? errorMessage = e.response?.data["message"];

  switch (status) {
    case 401:
      return Failure(
        type: FailureType.unauthorized,
        message: errorMessage ?? "Unauthorized",
        statusCode: status,
      );
      case 400:
      case 422:
        return Failure(
          type: FailureType.validation,
          message: errorMessage ?? "Invalid input",
          statusCode: status,
        );
      case 500:
        return Failure(
          type: FailureType.server,
          message: errorMessage ?? "Something went wrong on the server-side.",
          statusCode: status,
        );
    default:
      return Failure(
        type: FailureType.unknown,
        message: errorMessage ?? "Something went wrong",
        statusCode: status,
      );
  }
}
