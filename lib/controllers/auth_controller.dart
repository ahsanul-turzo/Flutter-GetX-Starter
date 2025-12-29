import 'package:flutter_get_starter/core/network/api_result.dart';
import 'package:get/get.dart';

import '../core/utils/logger.dart';
import '../features/auth/domain/entities/user_entity.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final AuthRepository authRepository;
  final StorageService storageService;

  AuthController({required this.loginUseCase, required this.authRepository, required this.storageService});

  // Observable state
  final Rx<UserEntity?> user = Rx<UserEntity?>(null);
  final RxString token = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStoredAuth();
  }

  // Load stored authentication
  void _loadStoredAuth() {
    final storedToken = storageService.getToken();
    if (storedToken != null && storedToken.isNotEmpty) {
      token.value = storedToken;
      isAuthenticated.value = true;
      // Optionally fetch current user
      getCurrentUser();
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final result = await loginUseCase.call(email, password);

      result.when(
        success: (authResponse) async {
          token.value = authResponse.token;
          user.value = authResponse.user;
          isAuthenticated.value = true;

          // Save to storage
          await storageService.saveToken(authResponse.token);
          await storageService.saveUserData({'id': authResponse.user.id, 'email': authResponse.user.email});

          Logger.info('Login successful for: ${authResponse.user.email}');

          // Navigate to home
          Get.offAllNamed(AppRoutes.home);

          Get.snackbar('Success', 'Welcome back, ${authResponse.user.name}!', snackPosition: SnackPosition.BOTTOM);
        },
        failure: (message) {
          Logger.error('Login failed', message);
          Get.snackbar('Login Failed', message, snackPosition: SnackPosition.BOTTOM);
        },
        loading: () {},
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Register
  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;

      final result = await authRepository.register(name, email, password);

      result.when(
        success: (authResponse) async {
          token.value = authResponse.token;
          user.value = authResponse.user;
          isAuthenticated.value = true;

          await storageService.saveToken(authResponse.token);
          await storageService.saveUserData({'id': authResponse.user.id, 'email': authResponse.user.email});

          Logger.info('Registration successful for: ${authResponse.user.email}');

          Get.offAllNamed(AppRoutes.home);

          Get.snackbar('Success', 'Account created successfully!', snackPosition: SnackPosition.BOTTOM);
        },
        failure: (message) {
          Logger.error('Registration failed', message);
          Get.snackbar('Registration Failed', message, snackPosition: SnackPosition.BOTTOM);
        },
        loading: () {},
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get current user
  Future<void> getCurrentUser() async {
    final result = await authRepository.getCurrentUser();

    result.when(
      success: (userData) {
        user.value = userData;
        Logger.info('User data loaded: ${userData.email}');
      },
      failure: (message) {
        Logger.warning('Failed to load user data: $message');
      },
      loading: () {},
    );
  }

  // Logout
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Call logout API
      await authRepository.logout();

      // Clear local data
      await storageService.removeToken();
      await storageService.clearUserData();

      token.value = '';
      user.value = null;
      isAuthenticated.value = false;

      Logger.info('User logged out successfully');

      Get.offAllNamed(AppRoutes.login);

      Get.snackbar('Logged Out', 'You have been logged out successfully', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user is authenticated
  bool get hasToken => token.value.isNotEmpty;
}
