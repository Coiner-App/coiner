import 'package:coiner/core/storage/storage_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorageImpl implements StorageBase {
  final SharedPreferencesAsync _sharedPrefs;

  SharedPrefsStorageImpl(this._sharedPrefs);

  @override
  Future<void> init() async {
    return;
  }

  @override
  Future<Object?> get(String key) async {
    try {
      final stringList = await _sharedPrefs.getStringList(key);
      if (stringList != null) return stringList;
    } catch (_) {}

    try {
      final stringVal = await _sharedPrefs.getString(key);
      if (stringVal != null) return stringVal;
    } catch (_) {}

    try {
      final boolVal = await _sharedPrefs.getBool(key);
      if (boolVal != null) return boolVal;
    } catch (_) {}

    try {
      final intVal = await _sharedPrefs.getInt(key);
      if (intVal != null) return intVal;
    } catch (_) {}

    try {
      final doubleVal = await _sharedPrefs.getDouble(key);
      if (doubleVal != null) return doubleVal;
    } catch (_) {}

    return null;
  }

  Future<T?> getTyped<T>(String key) async {
    if (T == String) {
      return await _sharedPrefs.getString(key) as T?;
    } else if (T == int) {
      return await _sharedPrefs.getInt(key) as T?;
    } else if (T == bool) {
      return await _sharedPrefs.getBool(key) as T?;
    } else if (T == double) {
      return await _sharedPrefs.getDouble(key) as T?;
    } else if (T == List<String>) {
      return await _sharedPrefs.getStringList(key) as T?;
    } else {
      throw Exception("Unsupported type for SharedPrefsStorage: $T");
    }
  }

  @override
  Future<void> set(String key, dynamic value) async {
    switch (value) {
      case String _:
        await _sharedPrefs.setString(key, value);
        break;
      case int _:
        await _sharedPrefs.setInt(key, value);
        break;
      case bool _:
        await _sharedPrefs.setBool(key, value);
        break;
      case double _:
        await _sharedPrefs.setDouble(key, value);
        break;
      case List<String> _:
        await _sharedPrefs.setStringList(key, value);
        break;
      default:
        throw Exception("Unsupported type for SharedPrefsStorage: ${value.runtimeType}");
    }
  }

  @override
  Future<void> remove(String key) async {
    await _sharedPrefs.remove(key);
  }

  @override
  Future<bool> contains(String key) async {
    return _sharedPrefs.containsKey(key);
  }

  @override
  Future<void> clear() async {
    await _sharedPrefs.clear();
  }

}