import 'package:get/get.dart';

import '../../../../core/network/api_result.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/usecases/get_items_usecase.dart';

class ExampleController extends GetxController {
  final GetItemsUseCase getItemsUseCase;

  ExampleController({required this.getItemsUseCase});

  // Observable state
  final RxList<ExampleEntity> items = <ExampleEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  // Fetch items
  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await getItemsUseCase.call();

      result.when(
        success: (data) {
          items.value = data;
          Logger.info('Successfully fetched ${data.length} items');
        },
        failure: (message) {
          error.value = message;
          Logger.error('Failed to fetch items', message);
          Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
        },
        loading: () {
          // Handle loading state if needed
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh items
  Future<void> refreshItems() async {
    try {
      isRefreshing.value = true;
      error.value = '';

      final result = await getItemsUseCase.call();

      result.when(
        success: (data) {
          items.value = data;
          Get.snackbar('Success', 'Items refreshed', snackPosition: SnackPosition.BOTTOM);
        },
        failure: (message) {
          error.value = message;
          Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
        },
        loading: () {},
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  // Get item by ID
  ExampleEntity? getItemById(String id) {
    return items.firstWhereOrNull((item) => item.id == id);
  }

  // Search items
  List<ExampleEntity> searchItems(String query) {
    if (query.isEmpty) return items;
    return items.where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
