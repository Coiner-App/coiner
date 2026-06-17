import 'package:coiner/core/logging/app_logger.dart';
import 'package:coiner/core/storage/secure_storage_storage_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JwtProvider extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final authStorage = ref.watch(secureStorageProvider);
    String? accessToken;
    try {
      accessToken = (await authStorage.get("accesstkn")) as String?;
    } catch (e) {
      AppLogger.warning("Access token read error:", e, StackTrace.current);
      await authStorage.remove("accesstkn");
      accessToken = null;
    }
    return accessToken;
  }

  Future<void> setToken(String? token) async {
    await ref.read(secureStorageProvider).set("accesstkn", token);
    state = AsyncData(token);
  }

  Future<void> clearToken() async {
    await ref.read(secureStorageProvider).remove("accesstkn");
    state = AsyncData(null);
  }
}

final jwtProvider = AsyncNotifierProvider<JwtProvider, String?>(() => JwtProvider());