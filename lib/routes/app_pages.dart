import 'package:get/get.dart';

import '../features/auth/presentation/bindings/auth_binding.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/splash/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage(), binding: AuthBinding()),
    GetPage(name: AppRoutes.register, page: () => const RegisterPage(), binding: AuthBinding()),
    // Add more routes as you build features
  ];
}
