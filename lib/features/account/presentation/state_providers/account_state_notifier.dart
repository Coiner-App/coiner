import 'package:coiner/features/account/data/repositories/account_repository_impl.dart';
import 'package:coiner/features/account/domain/models/current_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountStateNotifier extends AsyncNotifier<CurrentUser?> {
  @override
  Future<CurrentUser?> build() async {
    final repo = ref.watch(accountRepositoryProvider);

    final cachedUser = await repo.getCachedUser();

    refresh(force: false);

    return cachedUser;
  }

  Future<void> refresh({bool force = false}) async {
    state = const AsyncValue.loading();

    final rs = await ref.read(accountRepositoryProvider).getRemoteUser();

    if (rs.isSuccess && rs.data != null) {
      state = AsyncValue.data(rs.data);
    } else if (force) {
      state = AsyncValue.error(rs.failure!.message, StackTrace.current);
    } 
  }
}

final accountStateNotifier = AsyncNotifierProvider<AccountStateNotifier, CurrentUser?>(() => AccountStateNotifier());