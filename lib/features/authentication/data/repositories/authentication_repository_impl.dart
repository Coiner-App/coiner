import 'dart:developer';

import 'package:coiner/core/network/dio/dio_client.dart';
import 'package:coiner/core/network/jwt_provider.dart';
import 'package:coiner/core/network/result/api_result.dart';
import 'package:coiner/core/network/result/failure.dart';
import 'package:coiner/core/storage/cache/cache_storage_impl.dart';
import 'package:coiner/core/storage/secure_storage_storage_impl.dart';
import 'package:coiner/core/storage/shared_prefs_storage_impl.dart';
import 'package:coiner/core/storage/storage_base.dart';
import 'package:coiner/features/authentication/data/dto/auth_dto.dart';
import 'package:coiner/features/account/domain/models/current_user.dart';
import 'package:coiner/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final DioClient _dioClient;
  final StorageBase _authStorage;
  final StorageBase _cacheStorage;
  final JwtProvider _jwtProvider;

  AuthenticationRepositoryImpl(this._dioClient, this._authStorage, this._cacheStorage, this._jwtProvider);

  @override
  Future<void> initialize() async {
    final accessToken = await _authStorage.get("accesstkn");
    _jwtProvider.setToken(accessToken as String?);
  }

  @override
  Future<ApiResult<void>> login({required String email, required String password}) async {
    final ApiResult<AuthDto> rs = await _dioClient.postData<AuthDto>("/auth/login", data: {"email": email, "password": password}, parser: (json) => AuthDto.fromJson(json));
    if (rs.isSuccess) {
      await _authStorage.set("accesstkn", rs.data?.accessToken);
      log("access token: ${rs.data!.accessToken}");
      _jwtProvider.setToken(rs.data?.accessToken);
      await _authStorage.set("refreshtkn", rs.data?.refreshToken);
      await _cacheStorage.set("expiration", DateTime.now().add(Duration(seconds: rs.data!.expiresAfter)).toIso8601String());
      return ApiResult.success(null);
    }
    return ApiResult.failure(rs.failure!);
  }
  
  @override
  Future<ApiResult<AuthenticationStatus>> checkSession() async {
    final ApiResult<CurrentUser> rs = await _dioClient.getData<CurrentUser>("/api/user/me", parser: (rs) => CurrentUser.fromJson(rs));
    log("CheckSession: ${rs.failure?.message.toString()}\nCheckSession result: ${rs.isSuccess} ${rs.data.toString()}");
    if (rs.isSuccess) {
      await _cacheStorage.set("user", rs.data!.toJson());
      return ApiResult.success(AuthenticationStatus.authenticated);
    } else {
      switch (rs.failure!.type) { 
        case FailureType.unauthorized:
          await _cacheStorage.remove("user");
          return ApiResult.success(AuthenticationStatus.unauthenticated);
        case FailureType.network:
          final cachedUsr = await _cacheStorage.get("user");
          return cachedUsr != null ? ApiResult.success(AuthenticationStatus.cached) : ApiResult.success(AuthenticationStatus.offline);
        case FailureType.unknown:
          return ApiResult.success(AuthenticationStatus.error);
        default:
          return ApiResult.failure(rs.failure!);
      }
    }
  }

  @override
  Future<ApiResult<AuthenticationStatus>> refreshJwt() async {
    final refreshToken = await _authStorage.get("refreshtkn");
    String expiration = await _cacheStorage.get("expiration") as String;
    final expirationDate = DateTime.parse(expiration);
    if (refreshToken == null || expirationDate.isBefore(DateTime.now())) return await checkSession();
    final ApiResult<Response> rs = await _dioClient.postRaw("/auth/refresh", data: {"refresh_token": refreshToken});
    final accessToken = rs.data?.data['access_token'];
    if (accessToken != null) {
      await _authStorage.set("accesstkn", accessToken);
      _jwtProvider.setToken(accessToken as String?);
      return ApiResult.success(AuthenticationStatus.authenticated);
    } else {
      return ApiResult.failure(rs.failure!);
    }
  }

  @override
  Future<ApiResult<void>> logout() async {
    final ApiResult<Response> rs = await _dioClient.postRaw("/auth/logout");    
    if (rs.isSuccess) {
      _authStorage.remove("accesstkn");
      _authStorage.remove("refreshtkn");
      _jwtProvider.clearToken();
      _cacheStorage.remove("user");
    }
    return ApiResult.success(null);
  }
}

final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepositoryImpl(
    ref.read(dioClientProvider),
    ref.read(secureStorageProvider),
    ref.read(cacheStorageProvider),
    ref.watch(jwtProvider.notifier)
  );
});