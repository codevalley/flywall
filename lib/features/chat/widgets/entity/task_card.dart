import 'package:flutter/material.dart';
import '../../domain/models/task_entity.dart';
import '../../../../core/theme/theme.dart';
import 'base_entity_card.dart';

class TaskCard extends BaseEntityCard {
  final TaskEntity task;

  const TaskCard({
    super.key,
    required this.task,
    super.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 332,
        constraints: const BoxConstraints(
          minHeight: 140, // Minimum height for consistency
          maxHeight: 400,
        ),
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Content Area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Type Label
                  Text(
                    'TASK',
                    style: AppTypography.cardLabel,
                  ),
                  const SizedBox(height: 8),

                  // Task Description
                  Text(
                    task.description,
                    style: AppTypography.cardTitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Priority and Status
                  Row(
                    children: [
                      if (task.priority.isNotEmpty)
                        Text(
                          task.priority.toUpperCase(),
                          style: AppTypography.cardMetadata,
                        ),
                      if (task.priority.isNotEmpty && task.status.isNotEmpty)
                        const SizedBox(width: 42),
                      if (task.status.isNotEmpty)
                        Text(
                          task.status.toUpperCase(),
                          style: AppTypography.cardMetadata,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Section (Divider + Due Date & Arrow)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 0.5,
                    color: Colors.white,
                  ),
                ),

                // Due Date and Arrow
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (task.schedule.isNotEmpty)
                        Text(
                          _formatSchedule(task.schedule),
                          style: AppTypography.cardDate,
                        ),
                      Transform.rotate(
                        angle: -0.79,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatSchedule(String schedule) {
    // TODO: Implement proper schedule formatting
    return 'due in a day';
  }

  // Required by BaseEntityCard but not used in this implementation
  @override
  Widget buildIcon() => const SizedBox.shrink();

  @override
  String getTypeText() => 'TASK';

  @override
  Widget buildContent() => const SizedBox.shrink();

  @override
  Widget buildBottomRow() => const SizedBox.shrink();
}
