import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppLogger {
  AppLogger._();

  static const _platform = MethodChannel('coiner/logger');

  static void debug(String message) {
    if (!kDebugMode) return;
    dev.log(message, name: 'DEBUG');
    _sendToNative('DEBUG', message);
  }

  static void info(String message) {
    if (!kDebugMode) return;
    dev.log(message, name: 'INFO');
    _sendToNative('INFO', message);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      dev.log(message, name: 'WARNING', error: error, stackTrace: stackTrace);
    }
    _sendToNative('WARNING', '$message ${error ?? ""}');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      dev.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
    }
    _sendToNative('ERROR', '$message ${error ?? ""} \n$stackTrace');
  }
  
  static void _sendToNative(String level, String message) {
    if (kIsWeb) return;

    if (Platform.isAndroid) {
      _platform.invokeMethod('logToAndroidLog', {'level': level, 'message': message});
    } 
    
    else if (Platform.isIOS || Platform.isMacOS) {
      _platform.invokeMethod('logToOSLog', {'level': level, 'message': message});
    } 
    
    else if (Platform.isWindows) {
      throw UnimplementedError();
    }
  }
}