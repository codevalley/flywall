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
  Widget buildIcon() {
    return const Icon(
      Icons.check_circle_outline,
      color: Colors.white,
      size: 18,
    );
  }

  @override
  String getTypeText() => 'TASK';

  @override
  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          task.description,
          style: const TextStyle(
            color: AppColors.green,
            fontSize: 18,
            fontFamily: 'Blacker Display',
            fontWeight: FontWeight.w400,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (task.schedule.isNotEmpty)
          Text(
            task.schedule,
            style: TextStyle(
              color: Colors.white.withOpacity(0.74),
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  @override
  Widget buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (task.priority.isNotEmpty)
          Text(
            task.priority.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.74),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        if (task.status.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(
            task.status.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.74),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ],
    );
  }
}
