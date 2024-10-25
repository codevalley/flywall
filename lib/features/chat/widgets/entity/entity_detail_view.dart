// lib/features/chat/widgets/entity/entity_detail_view.dart

import 'package:flutter/material.dart';
import '../../domain/models/entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/entity_provider.dart';

class EntityDetailView extends ConsumerWidget {
  final Entity entity;
  final VoidCallback onClose;

  const EntityDetailView({
    super.key,
    required this.entity,
    required this.onClose,
  });

  Future<void> _handleAction(
      BuildContext context, WidgetRef ref, Function action) async {
    try {
      ref.read(entityActionsLoadingProvider.notifier).state = true;
      ref.read(entityActionsErrorProvider.notifier).state = null;

      await action();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action completed successfully')),
        );
        onClose();
      }
    } catch (e) {
      ref.read(entityActionsErrorProvider.notifier).state = e.toString();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      ref.read(entityActionsLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(entityActionsLoadingProvider);
    final error = ref.watch(entityActionsErrorProvider);
    final actions = ref.watch(entityActionsProvider);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header remains the same...
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getColorForType(entity.type).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
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
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                      color: Colors.black54,
                    ),
                ],
              ),
            ),

            if (error != null)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade50,
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),

            // Content section remains the same...
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entity.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildEntityContent(context),
                  const SizedBox(height: 16),
                  if (entity.tags.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entity.tags
                          .map((tag) => Chip(
                                label: Text(tag),
                                backgroundColor: _getColorForType(entity.type)
                                    .withOpacity(0.1),
                                labelStyle: TextStyle(
                                    color: _getColorForType(entity.type)),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Updated action buttons with loading state
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Add type-specific action buttons
                  ...switch (entity.type) {
                    EntityType.task => [
                        TextButton.icon(
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Mark Complete'),
                          onPressed: isLoading
                              ? null
                              : () => _handleAction(
                                    context,
                                    ref,
                                    () => actions.completeTask(entity.id),
                                  ),
                        ),
                      ],
                    EntityType.note => [
                        TextButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          onPressed: isLoading
                              ? null
                              : () => _handleAction(
                                    context,
                                    ref,
                                    () => actions.editNote(entity.id,
                                        entity.data['content'] ?? ''),
                                  ),
                        ),
                      ],
                    EntityType.person => [
                        TextButton.icon(
                          icon: const Icon(Icons.person_add),
                          label: const Text('Add to Team'),
                          onPressed: isLoading
                              ? null
                              : () => _handleAction(
                                    context,
                                    ref,
                                    () => actions.addPersonToTeam(entity.id),
                                  ),
                        ),
                      ],
                    EntityType.topic => [
                        TextButton.icon(
                          icon: const Icon(Icons.add_task),
                          label: const Text('Create Task'),
                          onPressed: isLoading
                              ? null
                              : () => _handleAction(
                                    context,
                                    ref,
                                    () =>
                                        actions.createTaskFromTopic(entity.id),
                                  ),
                        ),
                      ],
                  },
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Utility methods remain the same...
  Color _getColorForType(EntityType type) => switch (type) {
        EntityType.task => Colors.blue,
        EntityType.note => Colors.green,
        EntityType.person => Colors.purple,
        EntityType.topic => Colors.orange,
      };

  IconData _getIconForType(EntityType type) => switch (type) {
        EntityType.task => Icons.task_alt,
        EntityType.note => Icons.note,
        EntityType.person => Icons.person,
        EntityType.topic => Icons.topic,
      };

  // _buildEntityContent remains the same...
  Widget _buildEntityContent(BuildContext context) {
    switch (entity.type) {
      case EntityType.task:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${entity.data['status'] ?? 'New'}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (entity.data['due_date'] != null) ...[
              const SizedBox(height: 8),
              Text(
                'Due: ${entity.data['due_date']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              entity.data['description'] ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );

      case EntityType.note:
        return Text(
          entity.data['content'] ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        );

      case EntityType.person:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entity.data['email'] != null)
              Text(
                'Email: ${entity.data['email']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (entity.data['role'] != null) ...[
              const SizedBox(height: 8),
              Text(
                'Role: ${entity.data['role']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (entity.data['notes'] != null) ...[
              const SizedBox(height: 16),
              Text(
                entity.data['notes'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        );

      case EntityType.topic:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entity.data['description'] ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if ((entity.data['keywords'] as List?)?.isNotEmpty ?? false) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (entity.data['keywords'] as List)
                    .map((keyword) => Chip(
                          label: Text(keyword),
                          backgroundColor: Colors.grey.shade200,
                        ))
                    .toList(),
              ),
            ],
          ],
        );
    }
  }
}
