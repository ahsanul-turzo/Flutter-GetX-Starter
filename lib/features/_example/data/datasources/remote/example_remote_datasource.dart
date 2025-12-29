import '../../../../../core/error/app_exception.dart';
import '../../../../../services/api_service.dart';
import '../../models/example_model.dart';

abstract class ExampleRemoteDataSource {
  Future<List<ExampleModel>> getItems();
  Future<ExampleModel> getItemById(String id);
  Future<ExampleModel> createItem(Map<String, dynamic> data);
  Future<ExampleModel> updateItem(String id, Map<String, dynamic> data);
  Future<bool> deleteItem(String id);
}

class ExampleRemoteDataSourceImpl implements ExampleRemoteDataSource {
  final ApiService apiService;

  ExampleRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<ExampleModel>> getItems() async {
    try {
      final response = await apiService.get('/items');

      if (response.isOk && response.body != null) {
        final List<dynamic> data = response.body['data'] as List;
        return data.map((json) => ExampleModel.fromJson(json)).toList();
      } else {
        throw ServerException(response.body?['message'] ?? 'Failed to fetch items', statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e', originalError: e);
    }
  }

  @override
  Future<ExampleModel> getItemById(String id) async {
    try {
      final response = await apiService.get('/items/$id');

      if (response.isOk && response.body != null) {
        return ExampleModel.fromJson(response.body['data']);
      } else {
        throw ServerException(response.body?['message'] ?? 'Failed to fetch item', statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e', originalError: e);
    }
  }

  @override
  Future<ExampleModel> createItem(Map<String, dynamic> data) async {
    try {
      final response = await apiService.post('/items', data);

      if (response.isOk && response.body != null) {
        return ExampleModel.fromJson(response.body['data']);
      } else {
        throw ServerException(response.body?['message'] ?? 'Failed to create item', statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e', originalError: e);
    }
  }

  @override
  Future<ExampleModel> updateItem(String id, Map<String, dynamic> data) async {
    try {
      final response = await apiService.put('/items/$id', data);

      if (response.isOk && response.body != null) {
        return ExampleModel.fromJson(response.body['data']);
      } else {
        throw ServerException(response.body?['message'] ?? 'Failed to update item', statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e', originalError: e);
    }
  }

  @override
  Future<bool> deleteItem(String id) async {
    try {
      final response = await apiService.delete('/items/$id');
      return response.isOk;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e', originalError: e);
    }
  }
}
