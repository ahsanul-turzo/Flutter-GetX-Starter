import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);

    // Auth Dependencies (permanent - available throughout app)
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(Get.find()), fenix: true);

    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: Get.find()), fenix: true);

    Get.lazyPut(() => LoginUseCase(Get.find()), fenix: true);

    Get.put(
      AuthController(loginUseCase: Get.find(), authRepository: Get.find(), storageService: Get.find()),
      permanent: true,
    );
  }
}
