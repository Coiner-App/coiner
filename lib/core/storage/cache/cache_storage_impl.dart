import 'dart:convert';

import 'package:coiner/core/logging/app_logger.dart';
import 'package:coiner/core/storage/storage_base.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheStorageImpl implements StorageBase {
  final SharedPreferencesAsync _cachePrefs;

  CacheStorageImpl(this._cachePrefs);

  @override
  void init() {
    return;
  }

  @override
  Future<String?> get(String key) async {
    final jsonString = await _cachePrefs.getString(key);
    try {
      final json = jsonString;
      return json;
    } catch (e) {
      AppLogger.error("Error decoding JSON string: $jsonString", e, StackTrace.current);
      return null;
    }
  }

  @override
  Future<void> set(String key, dynamic value) async {
    final jsonString = jsonEncode(value);
    await _cachePrefs.setString(key, jsonString);
  }

  @override
  Future<void> remove(String key) async {
    await _cachePrefs.remove(key);
  }

  @override
  Future<bool> contains(String key) async {
    return _cachePrefs.containsKey(key);
  }

  @override
  Future<void> clear() async {
    await _cachePrefs.clear();
  }
}

final cacheStorageProvider = Provider<StorageBase>((ref) => CacheStorageImpl(SharedPreferencesAsync()));