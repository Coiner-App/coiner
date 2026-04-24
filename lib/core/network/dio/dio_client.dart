import 'package:dio/dio.dart';

import 'package:coiner/core/network/result/api_result.dart';
import 'package:coiner/core/network/result/error_mapper.dart';
import 'package:coiner/core/network/result/failure.dart';

class DioClient {
    DioClient();
    static final dio = Dio(BaseOptions(
        baseUrl: 'https://example.com',
        receiveDataWhenStatusError: true,
        responseType: ResponseType.json,
        //contentType: Headers.formUrlEncodedContentType,
        connectTimeout: Duration(seconds: 15)
    ));

    Future<ApiResult<Response>> getRaw(
          String path, {
            CancelToken? cancelToken,
            Map<String, dynamic>? data,
            ProgressCallback? onReceiveProgress,
            Options? options,
            Map<String, dynamic>? queryParameters,
          }
    ) async {
        try {
            final Response response = await dio.get(path, cancelToken: cancelToken, data: data, onReceiveProgress: onReceiveProgress, options: options, queryParameters: queryParameters);
            return ApiResult.success(response);
        } on DioException catch (e) {
            return ApiResult.failure(mapDioError(e));
        } catch (e) {
            return ApiResult.failure(Failure(type: FailureType.unknown, message: e.toString()));
        }
    }

    Future<ApiResult<T>> getData<T>(
          String path, {
            required T Function(dynamic json) parser,
            CancelToken? cancelToken,
            Map<String, dynamic>? data,
            ProgressCallback? onReceiveProgress,
            Options? options,
            Map<String, dynamic>? queryParameters,
          }
    ) async {
        try {
            final Response response = await dio.get(path, cancelToken: cancelToken, data: data, onReceiveProgress: onReceiveProgress, options: options, queryParameters: queryParameters);
            return ApiResult.success(parser(response.data));
        } on DioException catch (e) {
            return ApiResult.failure(mapDioError(e));
        } catch (e) {
            return ApiResult.failure(Failure(type: FailureType.unknown, message: e.toString()));
        }
    }

    Future<ApiResult<Response>> postRaw(
          String path, {
            CancelToken? cancelToken,
            Map<String, dynamic>? data,
            ProgressCallback? onReceiveProgress,
            ProgressCallback? onSendProgress,
            Options? options,
            Map<String, dynamic>? queryParameters
          }
    ) async {
        try {
            final Response response = await dio.post(path, cancelToken: cancelToken, data: data, onReceiveProgress: onReceiveProgress, onSendProgress: onSendProgress, options: options, queryParameters: queryParameters);
            return ApiResult.success(response);
        } on DioException catch (e) {
            return ApiResult.failure(mapDioError(e));
        } catch (e) {
            return ApiResult.failure(Failure(type: FailureType.unknown, message: e.toString()));
        }
    }

    Future<ApiResult<T>> postData<T>(
          String path, {
            required T Function(dynamic json) parser,
            CancelToken? cancelToken,
            Map<String, dynamic>? data,
            ProgressCallback? onReceiveProgress,
            ProgressCallback? onSendProgress,
            Options? options,
            Map<String, dynamic>? queryParameters
          }
    ) async {
        try {
            final Response response = await dio.post(path, cancelToken: cancelToken, data: data, onReceiveProgress: onReceiveProgress, onSendProgress: onSendProgress, options: options, queryParameters: queryParameters);
            return ApiResult.success(parser(response.data));
        } on DioException catch (e) {
            return ApiResult.failure(mapDioError(e));
        } catch (e) {
            return ApiResult.failure(Failure(type: FailureType.unknown, message: e.toString()));
        }
    }
}