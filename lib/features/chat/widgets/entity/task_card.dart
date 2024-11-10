import 'package:flutter/material.dart';
import '../../domain/models/task_entity.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/constants/ui_constants.dart';

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
        constraints: const BoxConstraints(
          minHeight: UIConstants.minCardHeight,
          maxHeight: UIConstants.maxCardHeight,
          maxWidth: UIConstants.maxCardWidth,
        ),
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: UIConstants.cardBorderWidth,
              color: AppColors.white,
            ),
            borderRadius: BorderRadius.circular(UIConstants.cardBorderRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: UIConstants.cardMainPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.task_alt,
                            color: AppColors.white,
                            size: UIConstants.cardIconSize,
                          ),
                          const SizedBox(width: UIConstants.mediumSpacing),
                          Text('TASK', style: AppTypography.cardLabel),
                        ],
                      ),
                      Transform.rotate(
                        angle: UIConstants.cardArrowRotation,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: AppColors.white,
                          size: UIConstants.cardArrowSize,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: UIConstants.extraLargeSpacing),
                  Text(
                    task.description,
                    style: AppTypography.cardTitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.schedule.isNotEmpty) ...[
                    const SizedBox(height: UIConstants.mediumSpacing),
                    Text(
                      _formatSchedule(task.schedule),
                      style: AppTypography.cardMetadata,
                    ),
                  ],
                ],
              ),
            ),
            if (task.status.isNotEmpty || task.priority.isNotEmpty) ...[
              Padding(
                padding: UIConstants.cardDividerPadding,
                child: Container(
                  height: UIConstants.cardDividerHeight,
                  color: AppColors.white,
                ),
              ),
              Padding(
                padding: UIConstants.cardBottomPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (task.priority.isNotEmpty)
                      Text(
                        task.priority.toUpperCase(),
                        style: AppTypography.cardMetadata,
                      ),
                    if (task.priority.isNotEmpty && task.status.isNotEmpty)
                      const SizedBox(width: UIConstants.extraLargeSpacing),
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
