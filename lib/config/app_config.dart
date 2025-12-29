import '../core/constants/app_constants.dart';

class AppConfig {
  static const String appName = 'Your App Name';
  static const String packageName = 'com.yourcompany.yourapp';

  // Environment
  static const bool isLive = false;

  // API Configuration
  static String get apiBaseUrl {
    switch (isLive) {
      case true:
        return AppConstants.apiBaseUrl;
      case false:
        return 'http://staging-api.yourapp.com/api';
    }
  }

  // Feature Flags
  static const bool enableCrashlytics = bool.fromEnvironment('ENABLE_CRASHLYTICS', defaultValue: false);

  static const bool enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: false);
}
