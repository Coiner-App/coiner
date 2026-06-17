import 'package:coiner/features/account/presentation/state_providers/account_state_notifier.dart';
import 'package:coiner/features/account/presentation/widgets/account_screen.dart';
import 'package:coiner/features/authentication/presentation/state_providers/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountView extends ConsumerWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountStateNotifier);
    ref.listen(accountStateNotifier, (previous, next) {
      if (!next.isLoading && next.hasValue && next.value == null) {
        ref.read(authStateProvider.notifier).refreshSession();
      }
    });
    if (state.value == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(accountStateNotifier.notifier).refresh(force: true),
      child: AccountScreen(user: state.value!));
  }
}
