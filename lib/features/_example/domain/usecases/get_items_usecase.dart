import '../../../../core/network/api_result.dart';
import '../entities/example_entity.dart';
import '../repositories/example_repository.dart';

class GetItemsUseCase {
  final ExampleRepository repository;

  GetItemsUseCase(this.repository);

  Future<ApiResult<List<ExampleEntity>>> call() async {
    return await repository.getItems();
  }
}
