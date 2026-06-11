import 'package:coiner/core/network/jwt_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthDioInterceptor extends InterceptorsWrapper {
  final Ref _ref;
  
  AuthDioInterceptor(this._ref);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['skipAuth'] == true) return handler.next(options);
    final token = await _ref.read(jwtProvider.future);
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}