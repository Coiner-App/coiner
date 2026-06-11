import 'package:coiner/app/app.dart';
import 'package:coiner/core/logging/app_logger.dart';
import 'package:coiner/core/network/jwt_provider.dart';
import 'package:coiner/core/storage/secure_storage_storage_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authStorage = FlutterSecureStorage();
  String? accessToken;
  try {
    accessToken = await authStorage.read(key: "accesstkn");
  } catch (e) {
    AppLogger.warning("Access token read error: ${e.toString()}", StackTrace.current);
    await authStorage.delete(key: "accesstkn");
    accessToken = null;
  }

  runApp(
    ProviderScope(
      overrides: [
        jwtProvider.overrideWithBuild((ref, _) => accessToken),
        secureStorageProvider.overrideWith((ref) => SecureStorageImpl(authStorage))
      ],
      child: const MainApp(),
    ),
  );
}