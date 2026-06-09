import 'package:coiner/app/app.dart';
import 'package:coiner/core/logging/provider_logger.dart';
import 'package:coiner/core/network/jwt_provider.dart';
import 'package:coiner/core/storage/secure_storage_storage_impl.dart';
import 'package:coiner/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*
    DEVELOPMENT DEBUG
   */
  // Catch synchronous Flutter UI crashes
  FlutterError.onError = (details) {
    AppLogger.error('FLUTTER UI CRASH: ${details.exception}', details.exception, details.stack);
  };

  // Catch async dart background crashes
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('DART ASYNC CRASH', error, stack);
    return true; 
  };

  final authStorage = FlutterSecureStorage();
  final accessToken = await authStorage.read(key: "accesstkn");

  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      overrides: [
        jwtProvider.overrideWithBuild((ref, _) => accessToken),
        secureStorageProvider.overrideWith((ref) => SecureStorageImpl(authStorage))
      ],
      child: const MainApp(),
    ),
  );
}