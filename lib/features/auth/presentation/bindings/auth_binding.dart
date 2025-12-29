import 'package:get/get.dart';

import '../../../../controllers/auth_controller.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: Get.find()));

    // UseCases
    Get.lazyPut(() => LoginUseCase(Get.find()));

    // Controller
    Get.put(
      AuthController(loginUseCase: Get.find(), authRepository: Get.find(), storageService: Get.find()),
      permanent: true,
    );
  }
}
