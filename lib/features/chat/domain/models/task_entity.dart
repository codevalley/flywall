import 'entity_base.dart';

class TaskEntity extends EntityBase {
  final String taskId;
  final String taskType;
  final String description;
  final String status;
  final List<String> actions;
  final Map<String, dynamic> people;
  final List<String> dependencies;
  final String schedule;
  final String priority;

  TaskEntity({
    required this.taskId,
    required this.taskType,
    required this.description,
    required this.status,
    required this.actions,
    required this.people,
    required this.dependencies,
    required this.schedule,
    required this.priority,
    required super.id,
    required super.timestamp,
    super.tags = const [],
  }) : super(
          type: EntityType.task,
          title: description,
        );

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'] ?? '',
      taskId: json['taskId'] ?? '',
      taskType: json['type'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      actions: List<String>.from(json['actions'] ?? []),
      people: Map<String, dynamic>.from(json['people'] ?? {}),
      dependencies: List<String>.from(json['dependencies'] ?? []),
      schedule: json['schedule'] ?? '',
      priority: json['priority'] ?? '',
      timestamp: EntityBase.parseDateTime(json['timestamp']) ?? DateTime.now(),
      tags: EntityBase.parseTags(json['tags']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'taskId': taskId,
      'type': taskType,
      'description': description,
      'status': status,
      'actions': actions,
      'people': people,
      'dependencies': dependencies,
      'schedule': schedule,
      'priority': priority,
      'timestamp': super.timestamp.toIso8601String(),
      'tags': super.tags,
    };
  }
}
