import 'package:flutter/material.dart';
import '../../domain/models/note_entity.dart';
import '../../../../core/theme/theme.dart';

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
                  // Note Type Label and Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.note,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'NOTE',
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

                  // Note Content
                  Text(
                    note.content,
                    style: AppTypography.cardTitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Bottom Section
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
