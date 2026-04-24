import 'failure.dart';

class ApiResult<T> {
  final T? data;
  final Failure? failure;

  ApiResult.success(this.data) : failure = null;
  ApiResult.failure(Failure f) : failure = f, data = null;

  bool get isSuccess => failure == null;
}