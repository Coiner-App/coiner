import 'package:coiner/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:coiner/features/authentication/domain/repositories/authentication_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Create the Notifier
class AuthStateNotifier extends AsyncNotifier<AuthenticationStatus> {
  @override
  Future<AuthenticationStatus> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final result = await repo.checkSession();
    
    if (result.isSuccess) {
      return result.data!;
    }
    
    return AuthenticationStatus.error; 
  }

  void refreshSession() {
    ref.invalidateSelf();
  }
}

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, AuthenticationStatus>(() => AuthStateNotifier());