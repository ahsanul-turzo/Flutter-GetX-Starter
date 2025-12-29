import '../../../../../core/error/app_exception.dart';
import '../../../../../services/storage_service.dart';
import '../../models/example_model.dart';

abstract class ExampleLocalDataSource {
  Future<List<ExampleModel>> getCachedItems();
  Future<void> cacheItems(List<ExampleModel> items);
  Future<void> clearCache();
}

class ExampleLocalDataSourceImpl implements ExampleLocalDataSource {
  final StorageService storageService;
  static const String _cacheKey = 'cached_items';

  ExampleLocalDataSourceImpl(this.storageService);

  @override
  Future<List<ExampleModel>> getCachedItems() async {
    try {
      final data = storageService.read<List>(_cacheKey);
      if (data != null) {
        return data.map((json) => ExampleModel.fromJson(json)).toList();
      }
      throw CacheException('No cached data found');
    } catch (e) {
      throw CacheException('Failed to get cached items: $e');
    }
  }

  @override
  Future<void> cacheItems(List<ExampleModel> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      await storageService.write(_cacheKey, jsonList);
    } catch (e) {
      throw CacheException('Failed to cache items: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await storageService.remove(_cacheKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
