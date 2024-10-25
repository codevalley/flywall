import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/entity.dart';
import 'entity_detail_view.dart';

class EntityCard extends ConsumerWidget {
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

  void _showEntityDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EntityDetailView(
        entity: entity,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showEntityDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 200,
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
                  const Spacer(),
                  // Quick action button based on entity type
                  IconButton(
                    icon: Icon(
                      _getQuickActionIcon(entity.type),
                      size: 20,
                    ),
                    onPressed: () => _handleQuickAction(context),
                    color: _getColorForType(entity.type),
                    tooltip: _getQuickActionTooltip(entity.type),
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
                _getPreviewText(entity),
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (entity.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 24,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: entity.tags.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 4),
                    itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getColorForType(entity.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        entity.tags[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: _getColorForType(entity.type),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getQuickActionIcon(EntityType type) {
    switch (type) {
      case EntityType.task:
        return Icons.check_circle_outline;
      case EntityType.note:
        return Icons.edit;
      case EntityType.person:
        return Icons.person_add;
      case EntityType.topic:
        return Icons.add_task;
    }
  }

  String _getQuickActionTooltip(EntityType type) {
    switch (type) {
      case EntityType.task:
        return 'Mark Complete';
      case EntityType.note:
        return 'Edit Note';
      case EntityType.person:
        return 'Add to Team';
      case EntityType.topic:
        return 'Create Task';
    }
  }

  String _getPreviewText(Entity entity) {
    switch (entity.type) {
      case EntityType.task:
        return 'Status: ${entity.data['status'] ?? 'New'}'
            '${entity.data['due_date'] != null ? ' • Due: ${entity.data['due_date']}' : ''}';
      case EntityType.note:
        return entity.data['content']?.toString() ?? '';
      case EntityType.person:
        return [
          entity.data['role'],
          entity.data['email'],
        ].where((item) => item != null).join(' • ');
      case EntityType.topic:
        return entity.data['description']?.toString() ?? '';
    }
  }

  void _handleQuickAction(BuildContext context) {
    // TODO: Implement quick actions
    switch (entity.type) {
      case EntityType.task:
        // Mark task as complete
        break;
      case EntityType.note:
        // Open note editor
        break;
      case EntityType.person:
        // Add to team
        break;
      case EntityType.topic:
        // Create task from topic
        break;
    }
  }
}
