import 'dart:developer';

import 'package:coiner/core/network/jwt_provider.dart';
import 'package:coiner/features/authentication/presentation/state_providers/auth_state_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthDioInterceptor extends InterceptorsWrapper {
  final Ref _ref;
  
  AuthDioInterceptor(this._ref);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(jwtProvider);
    log("token: $token");
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}