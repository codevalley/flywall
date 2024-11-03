import 'package:flutter/material.dart';
import '../../domain/models/note_entity.dart';
import '../../../../core/theme/theme.dart';
import 'base_entity_card.dart';

class NoteCard extends BaseEntityCard {
  final NoteEntity note;

  const NoteCard({
    super.key,
    required this.note,
    super.onTap,
  });

  @override
  Widget buildIcon() {
    return const Icon(
      Icons.note,
      color: Colors.white,
      size: 18,
    );
  }

  @override
  String getTypeText() => 'NOTE';

  @override
  Widget buildContent() {
    return Text(
      note.content,
      style: const TextStyle(
        color: AppColors.green,
        fontSize: 18,
        fontFamily: 'Blacker Display',
        fontWeight: FontWeight.w400,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget buildBottomRow() {
    final hasRelatedItems = note.relatedPeople.isNotEmpty ||
        note.relatedTasks.isNotEmpty ||
        note.relatedTopics.isNotEmpty;

    if (!hasRelatedItems) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          note.updatedAt,
          style: TextStyle(
            color: Colors.white.withOpacity(0.74),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          '${note.relatedPeople.length + note.relatedTasks.length + note.relatedTopics.length} LINKS',
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
