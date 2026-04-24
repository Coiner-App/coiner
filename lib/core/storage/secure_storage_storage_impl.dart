import 'package:coiner/core/storage/storage_base.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageImpl implements StorageBase {
  final FlutterSecureStorage _secureStorage;

  SecureStorageImpl(this._secureStorage);

  @override
  void init() {
    return;
  }

  @override
  Future<Object?> get(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> set(String key, dynamic value) async {
    if (value is! String) {
      throw Exception("SecureStorage only supports String values");
    }
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> remove(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<bool> contains(String key) async {
    return await _secureStorage.containsKey(key: key);
  }

  @override
  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }
}
