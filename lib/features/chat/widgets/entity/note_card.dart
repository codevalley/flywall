import 'package:flutter/material.dart';
import '../../domain/models/note_entity.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/constants/ui_constants.dart';

class NoteCard extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.note,
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
                            Icons.note,
                            color: AppColors.white,
                            size: UIConstants.cardIconSize,
                          ),
                          const SizedBox(width: UIConstants.mediumSpacing),
                          Text('NOTE', style: AppTypography.cardLabel),
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
                    note.content,
                    style: AppTypography.cardTitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (note.relatedPeople.isNotEmpty ||
                note.relatedTasks.isNotEmpty ||
                note.relatedTopics.isNotEmpty) ...[
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
                    Text(
                      note.updatedAt,
                      style: AppTypography.cardDate,
                    ),
                    Text(
                      '${note.relatedPeople.length + note.relatedTasks.length + note.relatedTopics.length} LINKS',
                      style: AppTypography.cardDate,
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
