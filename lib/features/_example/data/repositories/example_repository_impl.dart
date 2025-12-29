import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/repositories/example_repository.dart';
import '../datasources/local/example_local_datasource.dart';
import '../datasources/remote/example_remote_datasource.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleRemoteDataSource remoteDataSource;
  final ExampleLocalDataSource localDataSource;

  ExampleRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<ApiResult<List<ExampleEntity>>> getItems() async {
    try {
      final items = await remoteDataSource.getItems();
      await localDataSource.cacheItems(items);
      return Success(items);
    } on ServerException catch (e) {
      // Try to get cached data on server error
      try {
        final cachedItems = await localDataSource.getCachedItems();
        return Success(cachedItems);
      } catch (_) {
        return Failure(e.message, statusCode: e.statusCode);
      }
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }

  @override
  Future<ApiResult<ExampleEntity>> getItemById(String id) async {
    try {
      final item = await remoteDataSource.getItemById(id);
      return Success(item);
    } on ServerException catch (e) {
      return Failure(e.message, statusCode: e.statusCode);
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }

  @override
  Future<ApiResult<ExampleEntity>> createItem(Map<String, dynamic> data) async {
    try {
      final item = await remoteDataSource.createItem(data);
      return Success(item);
    } on ServerException catch (e) {
      return Failure(e.message, statusCode: e.statusCode);
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }

  @override
  Future<ApiResult<ExampleEntity>> updateItem(String id, Map<String, dynamic> data) async {
    try {
      final item = await remoteDataSource.updateItem(id, data);
      return Success(item);
    } on ServerException catch (e) {
      return Failure(e.message, statusCode: e.statusCode);
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }

  @override
  Future<ApiResult<bool>> deleteItem(String id) async {
    try {
      final result = await remoteDataSource.deleteItem(id);
      return Success(result);
    } on ServerException catch (e) {
      return Failure(e.message, statusCode: e.statusCode);
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }
}
