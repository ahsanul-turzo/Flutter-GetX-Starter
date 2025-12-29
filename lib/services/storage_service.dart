import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../core/constants/storage_keys.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  Future<StorageService> init() async {
    _box = GetStorage();
    await _box.initStorage;
    return this;
  }

  // Generic Methods
  Future<void> write<T>(String key, T value) async {
    await _box.write(key, value);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  T readWithDefault<T>(String key, T defaultValue) {
    return _box.read<T>(key) ?? defaultValue;
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> clear() async {
    await _box.erase();
  }

  bool hasData(String key) {
    return _box.hasData(key);
  }

  // Auth Related
  Future<void> saveToken(String token) async {
    await write(StorageKeys.accessToken, token);
  }

  String? getToken() {
    return read<String>(StorageKeys.accessToken);
  }

  Future<void> removeToken() async {
    await remove(StorageKeys.accessToken);
  }

  bool get hasToken => hasData(StorageKeys.accessToken);

  // User Data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await write(StorageKeys.userId, userData['id']);
    await write(StorageKeys.userEmail, userData['email']);
  }

  Future<void> clearUserData() async {
    await remove(StorageKeys.userId);
    await remove(StorageKeys.userEmail);
  }

  // Theme
  Future<void> saveThemeMode(bool isDark) async {
    await write(StorageKeys.isDarkMode, isDark);
  }

  bool get isDarkMode => readWithDefault(StorageKeys.isDarkMode, false);

  // Onboarding
  Future<void> setOnboardingComplete() async {
    await write(StorageKeys.hasSeenOnboarding, true);
  }

  bool get hasSeenOnboarding => readWithDefault(StorageKeys.hasSeenOnboarding, false);
}
