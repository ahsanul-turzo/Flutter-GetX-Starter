import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../controllers/example_controller.dart';
import '../widgets/example_item_card.dart';

class ExamplePage extends GetView<ExampleController> {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Feature'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () => _showSearch(context))],
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (controller.error.value.isNotEmpty && controller.items.isEmpty) {
          return ErrorView(message: controller.error.value, onRetry: controller.fetchItems);
        }

        // Empty state
        if (controller.items.isEmpty) {
          return EmptyState(
            icon: Icons.inbox_outlined,
            title: 'No Items Found',
            message: 'There are no items to display',
            actionText: 'Refresh',
            onAction: controller.fetchItems,
          );
        }

        // Success state - show items
        return RefreshIndicator(
          onRefresh: controller.refreshItems,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return ExampleItemCard(item: item, onTap: () => _showItemDetails(item.id));
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create page
          Get.snackbar('Info', 'Create functionality coming soon');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(context: context, delegate: ExampleSearchDelegate(controller));
  }

  void _showItemDetails(String id) {
    // Navigate to details page
    Get.snackbar('Info', 'Details page for item: $id');
  }
}

// Search Delegate
class ExampleSearchDelegate extends SearchDelegate {
  final ExampleController controller;

  ExampleSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = controller.searchItems(query);

    if (results.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text(item.description ?? ''),
          onTap: () => close(context, item.id),
        );
      },
    );
  }
}
