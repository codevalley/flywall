import 'entity_base.dart';
import 'task_entity.dart';
import 'topic_entity.dart';
import 'note_entity.dart';
import 'person_entity.dart';

class EntityFactory {
  static EntityBase fromJson(Map<String, dynamic> json) {
    final type = _parseEntityType(json['type']);

    switch (type) {
      case EntityType.task:
        return TaskEntity.fromJson(json);
      case EntityType.topic:
        return TopicEntity.fromJson(json);
      case EntityType.note:
        return NoteEntity.fromJson(json);
      case EntityType.person:
        return PersonEntity.fromJson(json);
    }
  }

  static EntityType _parseEntityType(String? type) {
    return EntityType.values.firstWhere(
      (e) => e.name.toLowerCase() == (type ?? '').toLowerCase(),
      orElse: () => EntityType.task,
    );
  }
}
