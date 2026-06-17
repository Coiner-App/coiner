import 'package:coiner/app/app.dart';
import 'package:coiner/core/logging/provider_logger.dart';
import 'package:coiner/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*
    DEVELOPMENT DEBUG
   */
  // Catch synchronous Flutter UI crashes
  FlutterError.onError = (details) {
    AppLogger.error('FLUTTER UI CRASH:', details.exception, details.stack);
  };

  // Catch async dart background crashes
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('DART ASYNC CRASH:', error, stack);
    return true; 
  };

  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      child: const MainApp(),
    ),
  );
}