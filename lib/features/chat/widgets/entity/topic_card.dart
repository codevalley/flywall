import 'package:flutter/material.dart';
import '../../domain/models/topic_entity.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/constants/ui_constants.dart';

class TopicCard extends StatelessWidget {
  final TopicEntity topic;
  final VoidCallback? onTap;

  const TopicCard({
    super.key,
    required this.topic,
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
                            Icons.topic,
                            color: AppColors.white,
                            size: UIConstants.cardIconSize,
                          ),
                          const SizedBox(width: UIConstants.mediumSpacing),
                          Text('TOPIC', style: AppTypography.cardLabel),
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
                  const SizedBox(height: UIConstants.largeSpacing),
                  Text(
                    topic.name,
                    style: AppTypography.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (topic.description.isNotEmpty) ...[
                    const SizedBox(height: UIConstants.smallSpacing),
                    Text(
                      topic.description,
                      style: AppTypography.cardMetadata,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (topic.keywords.isNotEmpty) ...[
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        topic.keywords.take(2).join(', ').toUpperCase(),
                        style: AppTypography.cardMetadata,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (topic.relatedPeople.isNotEmpty ||
                        topic.relatedTasks.isNotEmpty) ...[
                      const SizedBox(width: UIConstants.extraLargeSpacing),
                      Text(
                        '${topic.relatedPeople.length + topic.relatedTasks.length} LINKS',
                        style: AppTypography.cardMetadata,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
