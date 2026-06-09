import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class ProviderLogger extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    log('[ERROR] RIVERPOD: [${context.provider.name ?? context.provider.runtimeType}]');
    log('Exception: $error');
    log('StackTrace: $stackTrace');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    log('[DEBUG] RIVERPOD: [${context.provider.name ?? context.provider.runtimeType}] updated to: $newValue');
  }
}