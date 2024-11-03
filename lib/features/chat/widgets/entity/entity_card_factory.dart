import 'package:flutter/material.dart';
import '../../domain/models/entity_base.dart';
import '../../domain/models/task_entity.dart';
import '../../domain/models/topic_entity.dart';
import '../../domain/models/note_entity.dart';
import '../../domain/models/person_entity.dart';
import 'task_card.dart';
import 'topic_card.dart';
import 'note_card.dart';
import 'person_card.dart';

class EntityCardFactory {
  static Widget createCard(EntityBase entity, {VoidCallback? onTap}) {
    switch (entity.type) {
      case EntityType.task:
        return TaskCard(
          task: entity as TaskEntity,
          onTap: onTap,
        );
      case EntityType.topic:
        return TopicCard(
          topic: entity as TopicEntity,
          onTap: onTap,
        );
      case EntityType.note:
        return NoteCard(
          note: entity as NoteEntity,
          onTap: onTap,
        );
      case EntityType.person:
        return PersonCard(
          person: entity as PersonEntity,
          onTap: onTap,
        );
    }
  }
}
