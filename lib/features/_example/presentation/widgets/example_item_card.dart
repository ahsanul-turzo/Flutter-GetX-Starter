import 'package:flutter/material.dart';

import '../../domain/entities/example_entity.dart';

class ExampleItemCard extends StatelessWidget {
  final ExampleEntity item;
  final VoidCallback? onTap;

  const ExampleItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon/Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.inventory_2_outlined, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    if (item.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow icon
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
