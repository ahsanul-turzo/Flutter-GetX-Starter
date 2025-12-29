import '../core/constants/app_constants.dart';

class AppConfig {
  static const String appName = 'Your App Name';
  static const String packageName = 'com.yourcompany.yourapp';

  // Environment
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';

  // API Configuration
  static String get apiBaseUrl {
    switch (environment) {
      case 'production':
        return 'https://api.yourapp.com/api';
      case 'staging':
        return 'https://staging-api.yourapp.com/api';
      default:
        return AppConstants.apiBaseUrl;
    }
  }

  // Feature Flags
  static const bool enableCrashlytics = bool.fromEnvironment('ENABLE_CRASHLYTICS', defaultValue: false);

  static const bool enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: false);
}
