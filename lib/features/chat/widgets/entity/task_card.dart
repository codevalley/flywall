import 'package:flutter/material.dart';
import '../../domain/models/task_entity.dart';
import '../../../../core/theme/theme.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 140,
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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Type Label and Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.task_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'TASK',
                            style: AppTypography.cardLabel,
                          ),
                        ],
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
                  const SizedBox(height: 16),

                  // Task Description
                  Text(
                    task.description,
                    style: AppTypography.cardTitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Due date
                  if (task.schedule.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _formatSchedule(task.schedule),
                      style: AppTypography.cardMetadata,
                    ),
                  ],
                ],
              ),
            ),

            // Bottom Section with Status and Priority
            if (task.status.isNotEmpty || task.priority.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 0.5,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (task.priority.isNotEmpty)
                      Text(
                        task.priority.toUpperCase(),
                        style: AppTypography.cardMetadata,
                      ),
                    if (task.priority.isNotEmpty && task.status.isNotEmpty)
                      const SizedBox(width: 16),
                    if (task.status.isNotEmpty)
                      Text(
                        task.status.toUpperCase(),
                        style: AppTypography.cardMetadata,
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatSchedule(String schedule) {
    return 'due in a day';
  }
}
