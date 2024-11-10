import 'package:flutter/material.dart';
import '../../domain/models/person_entity.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/constants/ui_constants.dart';

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
                            Icons.person_outline,
                            color: AppColors.white,
                            size: UIConstants.cardIconSize,
                          ),
                          const SizedBox(width: UIConstants.mediumSpacing),
                          Text('PERSON', style: AppTypography.cardLabel),
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
                    person.name,
                    style: AppTypography.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (person.designation != null) ...[
                    const SizedBox(height: UIConstants.smallSpacing),
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
            if (person.relationType != null || person.importance != null) ...[
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
                    if (person.relationType != null)
                      Text(
                        person.relationType!.toUpperCase(),
                        style: AppTypography.cardMetadata,
                      ),
                    if (person.relationType != null &&
                        person.importance != null)
                      const SizedBox(width: UIConstants.extraLargeSpacing),
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
