import 'package:coiner/core/network/result/api_result.dart';

abstract class AuthenticationRepository {
  Future<ApiResult<void>> login({required String email, required String password});
  Future<ApiResult<AuthenticationStatus>> checkSession();
  Future<ApiResult<AuthenticationStatus>> refreshJwt();
  Future<ApiResult<void>> logout();
  //Future<int?> getCurrentUser();
}

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  cached,
  offline,
  error
}

