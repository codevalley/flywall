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

  String _getPreviewText(Entity entity) {
    switch (entity.type) {
      case EntityType.task:
        final dueDate = entity.data['due_date'];
        final status = entity.data['status'] ?? 'New';
        return [
          'Status: $status',
          if (dueDate != null) 'Due: $dueDate',
          _getRelatedEntitiesText(entity),
        ].where((text) => text.isNotEmpty).join('\n');

      case EntityType.note:
        return [
          entity.data['content']?.toString() ?? '',
          _getRelatedEntitiesText(entity),
        ].where((text) => text.isNotEmpty).join('\n');

      case EntityType.person:
        return [
          if (entity.data['role'] != null) 'Role: ${entity.data['role']}',
          if (entity.data['email'] != null) 'Email: ${entity.data['email']}',
          _getRelatedEntitiesText(entity),
        ].where((text) => text.isNotEmpty).join('\n');

      case EntityType.topic:
        return [
          entity.data['description']?.toString() ?? '',
          _getRelatedEntitiesText(entity),
        ].where((text) => text.isNotEmpty).join('\n');
    }
  }

  String _getRelatedEntitiesText(Entity entity) {
    final relatedEntities = <String>[];

    if (entity.data['related_people']?.isNotEmpty == true) {
      relatedEntities.add('${entity.data['related_people'].length} people');
    }
    if (entity.data['related_tasks']?.isNotEmpty == true) {
      relatedEntities.add('${entity.data['related_tasks'].length} tasks');
    }
    if (entity.data['related_topics']?.isNotEmpty == true) {
      relatedEntities.add('${entity.data['related_topics'].length} topics');
    }

    return relatedEntities.isEmpty
        ? ''
        : 'Related: ${relatedEntities.join(', ')}';
  }

  List<String> _getTags(Entity entity) {
    final tags = <String>[];

    switch (entity.type) {
      case EntityType.task:
        if (entity.data['status'] != null) {
          tags.add(entity.data['status']);
        }
        if (entity.data['priority'] != null) {
          tags.add(entity.data['priority']);
        }
        break;

      case EntityType.note:
        if (entity.data['categories'] is List) {
          tags.addAll((entity.data['categories'] as List).map((e) => e.toString()));
        }
        break;

      case EntityType.person:
        if (entity.data['role'] != null) {
          tags.add(entity.data['role']);
        }
        if (entity.data['team'] != null) {
          tags.add(entity.data['team']);
        }
        break;

      case EntityType.topic:
        if (entity.data['keywords'] is List) {
          tags.addAll((entity.data['keywords'] as List).map((e) => e.toString()));
        }
        break;
    }

    return tags;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = _getTags(entity);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => EntityDetailView(
            entity: entity,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 300,  // Increased width for better content display
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
                  Text(
                    'Created: ${_formatDate(entity.timestamp)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                entity.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                _getPreviewText(entity),
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 24,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tags.length,
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
                        tags[index],
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
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
