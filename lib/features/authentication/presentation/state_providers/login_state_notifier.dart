import 'dart:async';
import 'package:coiner/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:coiner/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:coiner/features/authentication/presentation/state_providers/auth_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginStateNotifier extends AsyncNotifier<void> {
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
      ref.read(authStateProvider.notifier).refreshSession();
      return true;
    } else {
      state = AsyncError(result.failure!.message, StackTrace.current);
      return false;
    }
  }
}

final loginStateProvider = AsyncNotifierProvider<LoginStateNotifier, void>(() => LoginStateNotifier());
