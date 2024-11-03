import 'entity_base.dart';

class TopicEntity extends EntityBase {
  final String topicId;
  final String name;
  final String description;
  final List<String> keywords;
  final List<String> relatedPeople;
  final List<String> relatedTasks;

  TopicEntity({
    required this.topicId,
    required this.name,
    required this.description,
    required this.keywords,
    required this.relatedPeople,
    required this.relatedTasks,
    required super.id,
    required super.timestamp,
    super.tags = const [],
  }) : super(
          type: EntityType.topic,
          title: name,
        );

  factory TopicEntity.fromJson(Map<String, dynamic> json) {
    return TopicEntity(
      id: json['id'] ?? '',
      topicId: json['topicId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      relatedPeople: List<String>.from(json['relatedPeople'] ?? []),
      relatedTasks: List<String>.from(json['relatedTasks'] ?? []),
      timestamp: EntityBase.parseDateTime(json['timestamp']) ?? DateTime.now(),
      tags: EntityBase.parseTags(json['tags']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'topicId': topicId,
      'name': name,
      'description': description,
      'keywords': keywords,
      'relatedPeople': relatedPeople,
      'relatedTasks': relatedTasks,
      'timestamp': super.timestamp.toIso8601String(),
      'tags': super.tags,
      'type': super.type.name,
    };
  }
}
