import 'package:coiner/core/network/dio/dio_client.dart';
import 'package:coiner/core/network/result/api_result.dart';
import 'package:coiner/core/network/result/failure.dart';
import 'package:coiner/core/storage/storage_base.dart';
import 'package:coiner/features/authentication/data/dto/auth_dto.dart';
import 'package:coiner/features/account/domain/models/current_user.dart';
import 'package:coiner/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final DioClient _dioClient;
  final StorageBase _authStorage;
  final StorageBase _cacheStorage;

  AuthenticationRepositoryImpl(this._dioClient, this._authStorage, this._cacheStorage);

  @override
  Future<ApiResult<void>> login({required String email, required String password}) async {
    final ApiResult<AuthDto> rs = await _dioClient.postData<AuthDto>("/auth/login", data: {"email": email, "password": password}, parser: (json) => AuthDto.fromJson(json));
    if (rs.isSuccess) {
      await _authStorage.set("accesstkn", rs.data?.accessToken);
      await _authStorage.set("refreshtkn", rs.data?.refreshToken);
      return ApiResult.success(null);
    }
    return ApiResult.failure(rs.failure!);
  }
  
  @override
  Future<ApiResult<AuthenticationStatus>> checkSession() async {
    final ApiResult<CurrentUser> rs = await _dioClient.getData<CurrentUser>("/api/user/me", parser: (rs) => CurrentUser.fromJson(rs));
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
  Future<ApiResult<void>> logout() async {
    final ApiResult<Response> rs = await _dioClient.postRaw("/auth/logout");    
    if (rs.isSuccess) {
      _authStorage.remove("accesstkn");
      _authStorage.remove("refreshtkn");
      _cacheStorage.remove("user");
    }
    return ApiResult.success(null);
  }
}