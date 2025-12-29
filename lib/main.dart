import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'config/app_binding.dart';
import 'config/app_config.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize GetStorage
  await GetStorage.init(AppConstants.storageBoxName);

  // Initialize services
  await _initServices();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Logger.info('App initialized successfully');
  Logger.info('Environment isLive: ${AppConfig.isLive}');
  Logger.info('API Base URL: ${AppConfig.apiBaseUrl}');
  runApp(const MyApp());
}

Future<void> _initServices() async {
  // Initialize StorageService
  await Get.putAsync(() => StorageService().init());

  Logger.info('Services initialized');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _getThemeMode(),

      // Initial binding
      initialBinding: AppBinding(),

      // Routes
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,

      // Default transitions
      defaultTransition: Transition.cupertino,

      // Localization (if needed)
      // locale: const Locale('en', 'US'),
      // fallbackLocale: const Locale('en', 'US'),
    );
  }

  ThemeMode _getThemeMode() {
    final storageService = Get.find<StorageService>();
    final isDark = storageService.isDarkMode;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
