import 'entity_base.dart';

class NoteEntity extends EntityBase {
  final String noteId;
  final String content;
  final String createdAt;
  final String updatedAt;
  final List<String> relatedPeople;
  final List<String> relatedTasks;
  final List<String> relatedTopics;

  NoteEntity({
    required this.noteId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.relatedPeople,
    required this.relatedTasks,
    required this.relatedTopics,
    required super.id,
    required super.timestamp,
    super.tags = const [],
  }) : super(
          type: EntityType.note,
          title: content.split('\n').first, // Use first line as title
        );

  factory NoteEntity.fromJson(Map<String, dynamic> json) {
    return NoteEntity(
      id: json['id'] ?? '',
      noteId: json['noteId'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      relatedPeople: List<String>.from(json['relatedPeople'] ?? []),
      relatedTasks: List<String>.from(json['relatedTasks'] ?? []),
      relatedTopics: List<String>.from(json['relatedTopics'] ?? []),
      timestamp: EntityBase.parseDateTime(json['timestamp']) ?? DateTime.now(),
      tags: EntityBase.parseTags(json['tags']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'noteId': noteId,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'relatedPeople': relatedPeople,
      'relatedTasks': relatedTasks,
      'relatedTopics': relatedTopics,
      'timestamp': super.timestamp.toIso8601String(),
      'tags': super.tags,
      'type': super.type.name,
    };
  }
}
