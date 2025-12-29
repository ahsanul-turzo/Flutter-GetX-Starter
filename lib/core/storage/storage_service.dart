import 'package:get_storage/get_storage.dart';

abstract class StorageService {
  Future<void> write<T>(String key, T value);
  T? read<T>(String key);
  Future<void> remove(String key);
  Future<void> clear();
  bool hasData(String key);
  T? readWithDefault<T>(String key, T defaultValue);
}

class GetStorageService implements StorageService {
  final GetStorage _box;

  GetStorageService(this._box);

  @override
  Future<void> write<T>(String key, T value) async {
    await _box.write(key, value);
  }

  @override
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  @override
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  @override
  Future<void> clear() async {
    await _box.erase();
  }

  @override
  bool hasData(String key) {
    return _box.hasData(key);
  }

  @override
  T? readWithDefault<T>(String key, T defaultValue) {
    return _box.read<T>(key) ?? defaultValue;
  }
}
