import 'package:get/get.dart';

import '../../data/datasources/local/example_local_datasource.dart';
import '../../data/datasources/remote/example_remote_datasource.dart';
import '../../data/repositories/example_repository_impl.dart';
import '../../domain/repositories/example_repository.dart';
import '../../domain/usecases/get_items_usecase.dart';
import '../controllers/example_controller.dart';

class ExampleBinding extends Bindings {
  @override
  void dependencies() {
    // DataSources
    Get.lazyPut<ExampleRemoteDataSource>(() => ExampleRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<ExampleLocalDataSource>(() => ExampleLocalDataSourceImpl(Get.find()));

    // Repository
    Get.lazyPut<ExampleRepository>(
      () => ExampleRepositoryImpl(remoteDataSource: Get.find(), localDataSource: Get.find()),
    );

    // UseCases
    Get.lazyPut(() => GetItemsUseCase(Get.find()));

    // Controller
    Get.lazyPut(() => ExampleController(getItemsUseCase: Get.find()));
  }
}
