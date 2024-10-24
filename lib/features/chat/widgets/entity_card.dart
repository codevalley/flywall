// chat/widgets/entity_card.dart
import 'package:flutter/material.dart';
import '../domain/models/entity.dart';

class EntityCard extends StatelessWidget {
  final Entity entity;

  const EntityCard({
    super.key,
    required this.entity,
  });

  Color _getColorForType(EntityType type) {
    switch (type) {
      case EntityType.task:
        return Colors.blue;
      case EntityType.note:
        return Colors.green;
      case EntityType.person:
        return Colors.purple;
      case EntityType.topic:
        return Colors.orange;
    }
  }

  IconData _getIconForType(EntityType type) {
    switch (type) {
      case EntityType.task:
        return Icons.task_alt;
      case EntityType.note:
        return Icons.note;
      case EntityType.person:
        return Icons.person;
      case EntityType.topic:
        return Icons.topic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Handle entity tap
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 200, // Fixed width for consistent layout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForType(entity.type),
                    color: _getColorForType(entity.type),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entity.type.name.toUpperCase(),
                    style: TextStyle(
                      color: _getColorForType(entity.type),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                entity.title,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                // Show a preview of the data or description
                entity.data['description']?.toString() ?? '',
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
