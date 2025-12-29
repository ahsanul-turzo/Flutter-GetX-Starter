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
    // FOR DEMO: Return mock data instead of API call
    // Comment this out and uncomment the real API call when ready
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    return [
      const ExampleModel(
        id: '1',
        name: 'Sample Item 1',
        description: 'This is a sample item demonstrating the clean architecture',
      ),
      const ExampleModel(
        id: '2',
        name: 'Sample Item 2',
        description: 'Another example showing the separation of concerns',
      ),
      const ExampleModel(
        id: '3',
        name: 'Sample Item 3',
        description: 'GetX state management with reactive programming',
      ),
      const ExampleModel(
        id: '4',
        name: 'Sample Item 4',
        description: 'Clean code with domain, data, and presentation layers',
      ),
      const ExampleModel(
        id: '5',
        name: 'Sample Item 5',
        description: 'Production-ready architecture for scalable apps',
      ),
    ];

    // REAL API CALL (uncomment when your API is ready):
    /*
    try {
      final response = await apiService.get('/items');

      if (response.isOk && response.body != null) {
        final List<dynamic> data = response.body['data'] as List;
        return data.map((json) => ExampleModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.body?['message'] ?? 'Failed to fetch items',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e', originalError: e);
    }
    */
  }

  // Keep other methods as they are...
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
