import 'package:coiner/core/network/jwt_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthDioInterceptor extends InterceptorsWrapper {
  final Ref _ref;
  
  AuthDioInterceptor(this._ref);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra['skipAuth'] == true) return handler.next(options);
    final token = _ref.read(jwtProvider);
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}