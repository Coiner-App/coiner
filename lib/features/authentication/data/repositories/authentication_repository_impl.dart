import 'package:coiner/core/network/dio/dio_client.dart';
import 'package:coiner/core/network/jwt_provider.dart';
import 'package:coiner/core/network/result/api_result.dart';
import 'package:coiner/core/network/result/error_mapper.dart';
import 'package:coiner/core/network/result/failure.dart';
import 'package:coiner/core/storage/cache/cache_storage_impl.dart';
import 'package:coiner/core/storage/secure_storage_storage_impl.dart';
import 'package:coiner/core/storage/storage_base.dart';
import 'package:coiner/features/account/data/repositories/account_repository_impl.dart';
import 'package:coiner/features/account/domain/repositories/account_repository.dart';
import 'package:coiner/features/authentication/data/dto/auth_dto.dart';
import 'package:coiner/features/account/domain/models/current_user.dart';
import 'package:coiner/features/authentication/domain/repositories/authentication_repository.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final DioClient _dioClient;
  final Dio _authDio;
  final AccountRepository _accountRepository;
  final StorageBase _authStorage;
  final StorageBase _cacheStorage;
  final JwtProvider _jwtProvider;

  AuthenticationRepositoryImpl(this._dioClient, this._authDio, this._accountRepository, this._authStorage, this._cacheStorage, this._jwtProvider);

  @override
  Future<ApiResult<void>> login({required String email, required String password}) async {
    final ApiResult<AuthDto> rs = await _dioClient.postData<AuthDto>("/auth/login", data: {"email": email, "password": password}, parser: (json) => AuthDto.fromJson(json));
    if (rs.isSuccess) {
      await _jwtProvider.setToken(rs.data?.accessToken);
      await _authStorage.set("refreshtkn", rs.data?.refreshToken);
      await _cacheStorage.set("expiration", DateTime.now().add(Duration(seconds: rs.data!.expiresAfter)).toIso8601String());
      return ApiResult.success(null);
    }
    return ApiResult.failure(rs.failure!);
  }
  
  @override
  Future<ApiResult<AuthenticationStatus>> checkSession() async {
    final ApiResult<CurrentUser> rs = await _dioClient.getData<CurrentUser>("/api/user/me", parser: (rs) => CurrentUser.fromJson(rs));
    if (rs.isSuccess) {
      await _accountRepository.setCachedUser(rs.data);
      return ApiResult.success(AuthenticationStatus.authenticated);
    } else {
      switch (rs.failure!.type) { 
        case FailureType.unauthorized:
          await _accountRepository.setCachedUser(null);
          return ApiResult.success(AuthenticationStatus.unauthenticated);
        case FailureType.network:
          final cachedUsr = await _accountRepository.getCachedUser();
          return cachedUsr != null ? ApiResult.success(AuthenticationStatus.cached) : ApiResult.success(AuthenticationStatus.offline);
        case FailureType.unknown:
          return ApiResult.success(AuthenticationStatus.error);
        default:
          return ApiResult.failure(rs.failure!);
      }
    }
  }

  @override
  Future<ApiResult<String?>> refreshJwt() async {
    final refreshToken = await _authStorage.get("refreshtkn");
    String? expiration = await _cacheStorage.get("expiration") as String?;
    final expirationDate = expiration == null ? null : DateTime.parse(expiration);
    if (refreshToken == null || expirationDate == null || expirationDate.isBefore(DateTime.now())) {
      return ApiResult.failure(Failure(type: FailureType.unauthorized, statusCode: 401, message: "Session expired"));
    }
    final Response rs;
    try {
      rs = await _authDio.post(
        "/auth/refresh",
        data: {"refresh_token": refreshToken},
        options: Options(
        extra: {'skipAuth': true},
      ));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    } catch (e) {
      return ApiResult.failure(Failure(type: FailureType.unknown, message: e.toString()));
    }
    final String? accessToken = rs.data["access_token"];
    if (accessToken != null) {
      await _jwtProvider.setToken(accessToken);
      return ApiResult.success(accessToken);
    } else {
      return ApiResult.failure(Failure(type: FailureType.server, message: "Server did not report access token, contact support."));
    }
  }

  @override
  Future<ApiResult<void>> logout() async {
    final ApiResult<Response> rs = await _dioClient.postRaw("/auth/logout",
    data: {"refresh_token": await _authStorage.get("refreshtkn")},
    options: Options(
      extra: {'skipAuth': true},
    ));
    if (rs.isSuccess) {
      await Future.wait([
        _authStorage.remove("refreshtkn"),
        _cacheStorage.remove("expiration"),
        _accountRepository.setCachedUser(null),
        _jwtProvider.clearToken()
      ]);
      return ApiResult.success(null);
    }
    return ApiResult.failure(rs.failure!);
  }

  @override
  Future<bool> forceLogout() async {
    try {
      await _authDio.post("/auth/logout", data: {"refresh_token": await _authStorage.get("refreshtkn")});
    } catch (_) {}
    try {
      await Future.wait([
        _authStorage.remove("refreshtkn"),
        _cacheStorage.remove("expiration"),
        _accountRepository.setCachedUser(null),
        _jwtProvider.clearToken()
      ]);
    } catch(e) {
      return false;
    }
    return true;
  }
}

final authRepositoryProvider = Provider<AuthenticationRepository>((ref) =>
  AuthenticationRepositoryImpl(
    ref.read(dioClientProvider),
    ref.read(authDioProvider),
    ref.watch(accountRepositoryProvider),
    ref.read(secureStorageProvider),
    ref.read(cacheStorageProvider),
    ref.watch(jwtProvider.notifier)
  ));