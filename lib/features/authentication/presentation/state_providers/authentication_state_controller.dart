import 'dart:async';
import 'dart:developer';
import 'package:coiner/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:coiner/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationStateController extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.watch(authRepositoryProvider);
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncLoading();
    final result = await _repository.login(email: email, password: password);
    if (result.isSuccess) {
      state = const AsyncData(null);
      return true;
    } else {
      state = AsyncError(result.failure!.message, StackTrace.current);
      return false;
    }
  }
}

// The Provider that exposes this controller to your Login Screen
final authStateControllerProvider = AsyncNotifierProvider<AuthenticationStateController, void>(() {
  return AuthenticationStateController();
});
