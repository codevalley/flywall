import 'package:flutter/material.dart';
import '../../domain/models/person_entity.dart';
import '../../../../core/theme/theme.dart';
import 'base_entity_card.dart';

class PersonCard extends BaseEntityCard {
  final PersonEntity person;

  const PersonCard({
    super.key,
    required this.person,
    super.onTap,
  });

  @override
  Widget buildIcon() {
    return const Icon(
      Icons.person_outline,
      color: Colors.white,
      size: 18,
    );
  }

  @override
  String getTypeText() => 'PERSON';

  @override
  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          person.name,
          style: const TextStyle(
            color: AppColors.green,
            fontSize: 18,
            fontFamily: 'Blacker Display',
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (person.designation != null)
          Text(
            person.designation!,
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
    if (person.relationType == null && person.importance == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (person.relationType != null)
          Text(
            person.relationType!.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.74),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        if (person.importance != null) ...[
          const SizedBox(width: 8),
          Text(
            person.importance!.toUpperCase(),
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
