import 'failure.dart';

class ApiResult<T> {
  final T? data;
  final Failure? failure;

  ApiResult.success(this.data) : failure = null;
  ApiResult.failure(this.failure) : data = null;

  bool get isSuccess => data != null;
}