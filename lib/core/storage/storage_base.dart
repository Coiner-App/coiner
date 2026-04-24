abstract class StorageBase {
  void init() {
    return;
  }
  Future<Object?> get(String key);
  Future<void> set(String key, dynamic value);
  Future<void> remove(String key);
  Future<bool> contains(String key);
  Future<void> clear();
}