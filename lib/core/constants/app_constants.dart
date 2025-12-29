abstract class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://your-api.com/api';
  static const String rootUrl = 'https://your-api.com';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String storageBoxName = 'app_storage';
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // API Settings
  static const int apiTimeout = 30;
  static const bool enableApiLogs = true;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration
  static const Duration cacheExpiration = Duration(hours: 24);

  // Retry Configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
