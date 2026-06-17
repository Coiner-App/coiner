import 'package:coiner/core/logging/app_logger.dart';
import 'package:coiner/core/network/jwt_provider.dart';
import 'package:coiner/core/network/result/failure.dart';
import 'package:coiner/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshDioInterceptor extends QueuedInterceptorsWrapper {
  // ignore: unused_field
  final Dio _dio;
  final Dio _refreshDio;
  final Ref _ref;

  RefreshDioInterceptor(this._dio, this._refreshDio, this._ref);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.extra['skipAuth'] == true) return handler.next(err);

    final int? statusCode = err.response?.statusCode;
    if (statusCode == 401) {
      if (await _ref.read(jwtProvider.future) == null) { // User has never signed in, no point of refreshing
        return handler.next(err);
      }
      try {
        final authRepo = _ref.read(authRepositoryProvider);
        final rs = await authRepo.refreshJwt();

        if (rs.isSuccess && rs.data != null) {
          final token = rs.data!;
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $token';

          final response = await _refreshDio.fetch(options);
          return handler.resolve(response);
        } else if (rs.failure?.statusCode == 401 || rs.failure?.type == FailureType.unauthorized) {
          await authRepo.forceLogout();
          return handler.reject(err);
        } else {
          return handler.next(err);
        }
      } catch (e) {
        AppLogger.error("Error refreshing token", e, StackTrace.current);
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

}