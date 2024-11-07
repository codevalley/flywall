import 'package:flutter/material.dart';
import '../../domain/models/person_entity.dart';
import '../../../../core/theme/theme.dart';

class PersonCard extends StatelessWidget {
  final PersonEntity person;
  final VoidCallback? onTap;

  const PersonCard({
    super.key,
    required this.person,
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
                  // Person Type Label and Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'PERSON',
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

                  // Person Name
                  Text(
                    person.name,
                    style: AppTypography.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (person.designation != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      person.designation!,
                      style: AppTypography.cardMetadata,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Bottom Section
            if (person.relationType != null || person.importance != null) ...[
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
                    if (person.relationType != null)
                      Text(
                        person.relationType!.toUpperCase(),
                        style: AppTypography.cardMetadata,
                      ),
                    if (person.relationType != null &&
                        person.importance != null)
                      const SizedBox(width: 16),
                    if (person.importance != null)
                      Text(
                        person.importance!.toUpperCase(),
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
}
