import 'package:flutter/material.dart';
import '../../domain/models/topic_entity.dart';
import '../../../../core/theme/theme.dart';
import 'base_entity_card.dart';

class TopicCard extends BaseEntityCard {
  final TopicEntity topic;

  const TopicCard({
    super.key,
    required this.topic,
    super.onTap,
  });

  @override
  Widget buildIcon() {
    return const Icon(
      Icons.topic,
      color: Colors.white,
      size: 18,
    );
  }

  @override
  String getTypeText() => 'TOPIC';

  @override
  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          topic.name,
          style: const TextStyle(
            color: AppColors.green,
            fontSize: 18,
            fontFamily: 'Blacker Display',
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (topic.description.isNotEmpty)
          Text(
            topic.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.74),
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  @override
  Widget buildBottomRow() {
    if (topic.keywords.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          topic.keywords.take(2).join(', ').toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.74),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
