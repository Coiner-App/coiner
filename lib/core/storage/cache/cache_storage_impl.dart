import 'dart:convert';
import 'dart:developer';

import 'package:coiner/core/storage/storage_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheStorageImpl implements StorageBase {
  final SharedPreferencesAsync _cachePrefs;

  CacheStorageImpl(this._cachePrefs);

  @override
  void init() {
    return;
  }

  @override
  Future<Object?> get(String key) async {
    final jsonString = await _cachePrefs.getString(key);
    try {
      final json = jsonString != null ? jsonDecode(jsonString) : null;
      return json;
    } catch (_) {
      log("Invalid JSON format for key: $key");
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