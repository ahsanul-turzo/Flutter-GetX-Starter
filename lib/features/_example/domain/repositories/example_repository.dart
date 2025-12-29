import '../../../../core/network/api_result.dart';
import '../entities/example_entity.dart';

abstract class ExampleRepository {
  Future<ApiResult<List<ExampleEntity>>> getItems();
  Future<ApiResult<ExampleEntity>> getItemById(String id);
  Future<ApiResult<ExampleEntity>> createItem(Map<String, dynamic> data);
  Future<ApiResult<ExampleEntity>> updateItem(String id, Map<String, dynamic> data);
  Future<ApiResult<bool>> deleteItem(String id);
}
