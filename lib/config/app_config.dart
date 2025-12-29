import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_get_starter/config/dot_env_config.dart';

import '../core/constants/app_constants.dart';

class AppConfig {
  static const String appName = 'Your App Name';
  static const String packageName = 'com.yourcompany.yourapp';

  // Environment
  static bool isLive = DotEnvConfig.isLive;

  // API Configuration
  static String get apiBaseUrl {
    if (isLive) {
      return dotenv.env['API_URL'] ?? AppConstants.apiBaseUrl;
    }
    return 'http://staging-api.yourapp.com/api';
  }

  // Feature Flags
  static const bool enableCrashlytics = bool.fromEnvironment('ENABLE_CRASHLYTICS', defaultValue: false);

  static const bool enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: false);
}
