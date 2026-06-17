import 'package:coiner/core/network/jwt_provider.dart';
import 'package:coiner/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:coiner/features/authentication/domain/repositories/authentication_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStateNotifier extends AsyncNotifier<AuthenticationStatus> {

  @override
  Future<AuthenticationStatus> build() async {
    ref.watch(jwtProvider);
    return await checkSession();
  }

  Future<AuthenticationStatus> checkSession() async {
    final rs = await ref.read(authRepositoryProvider).checkSession();
    
    if (rs.isSuccess) {
      return rs.data!;
    }
    
    return AuthenticationStatus.error; 
  }

  Future<bool> logout() async {
    state = const AsyncValue.loading();
    final rs = await ref.read(authRepositoryProvider).logout();
    return rs.isSuccess ? true : false;
  }

  void refreshSession() {
    ref.invalidateSelf();
  }
}

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, AuthenticationStatus>(() => AuthStateNotifier());