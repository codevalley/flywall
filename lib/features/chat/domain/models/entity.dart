enum EntityType { task, note, person, topic }

class Entity {
  final String id;
  final EntityType type;
  final String title;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final List<String> tags;

  const Entity({
    required this.id,
    required this.type,
    required this.title,
    required this.data,
    required this.timestamp,
    this.tags = const [],
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['id'] as String,
      type: EntityType.values.firstWhere(
        (e) => e.name == json['type'] as String,
        orElse: () => EntityType.task,
      ),
      title: json['title'] as String,
      data: json['data'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'tags': tags,
    };
  }
}
