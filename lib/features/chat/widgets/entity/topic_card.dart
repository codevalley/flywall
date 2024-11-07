import 'package:flutter/material.dart';
import '../../domain/models/topic_entity.dart';
import '../../../../core/theme/theme.dart';

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
        width: double.infinity,
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
                  // Topic Type Label and Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.topic,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'TOPIC',
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
                  const SizedBox(height: 12),

                  // Topic Name
                  Text(
                    topic.name,
                    style: AppTypography.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (topic.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
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

            // Bottom Section
            if (topic.keywords.isNotEmpty) ...[
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
                      const SizedBox(width: 16),
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
