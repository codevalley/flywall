// lib/features/chat/domain/models/message.dart

import 'entity.dart';

enum MessageType { text, entity, system }

class Message {
  final String id;
  final String content;
  final MessageType type;
  final List<Entity> entities;  // We'll convert the map to a flat list
  final DateTime timestamp;
  final Map<String, dynamic>? tokenUsage;
  final String? threadId;
  final bool isThreadComplete;
  final Map<String, int> updatedEntities;
  final String? newPrompt;

  const Message({
    required this.id,
    required this.content,
    this.type = MessageType.text,
    this.entities = const [],
    required this.timestamp,
    this.tokenUsage,
    this.threadId,
    this.isThreadComplete = false,
    this.updatedEntities = const {},
    this.newPrompt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // Generate a unique message ID if none provided
    final id = json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString();

    // Use 'response' field as content, falling back to 'content' if not present
    final content = json['response'] as String? ?? json['content'] as String? ?? '';

    // Parse entities from the new structure
    final entities = <Entity>[];
    if (json['entities'] is Map<String, dynamic>) {
      final entitiesMap = json['entities'] as Map<String, dynamic>;

      // Process tasks
      if (entitiesMap['tasks'] is List) {
        for (final task in entitiesMap['tasks']) {
          entities.add(Entity(
            id: task['task_id'],
            type: EntityType.task,
            title: task['title'] ?? 'Untitled Task',
            data: task,
            timestamp: DateTime.parse(task['created_at']),
          ));
        }
      }

      // Process notes
      if (entitiesMap['notes'] is List) {
        for (final note in entitiesMap['notes']) {
          entities.add(Entity(
            id: note['note_id'],
            type: EntityType.note,
            title: note['content'] ?? 'Untitled Note',
            data: note,
            timestamp: DateTime.parse(note['created_at']),
          ));
        }
      }

      // Process people
      if (entitiesMap['people'] is List) {
        for (final person in entitiesMap['people']) {
          entities.add(Entity(
            id: person['person_id'],
            type: EntityType.person,
            title: person['name'] ?? 'Unnamed Person',
            data: person,
            timestamp: DateTime.parse(person['created_at']),
          ));
        }
      }

      // Process topics
      if (entitiesMap['topics'] is List) {
        for (final topic in entitiesMap['topics']) {
          entities.add(Entity(
            id: topic['topic_id'],
            type: EntityType.topic,
            title: topic['name'] ?? 'Untitled Topic',
            data: topic,
            timestamp: DateTime.parse(topic['created_at']),
          ));
        }
      }
    }

    // Parse token usage
    final tokenUsage = json['token_usage'] as Map<String, dynamic>?;

    // Parse updated entities
    final updatedEntities = (json['updated_entities'] as Map<String, dynamic>?)
        ?.map((key, value) => MapEntry(key, value as int)) ??
        {};

    // Parse thread completion status
    final isThreadComplete = json['is_thread_complete'] as bool? ?? false;

    // Get suggested new prompt if present
    final newPrompt = json['new_prompt'] as String?;

    return Message(
      id: id,
      content: content,
      type: MessageType.values.firstWhere(
            (t) => t.name == (json['type'] as String?),
        orElse: () => MessageType.text,
      ),
      entities: entities,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      tokenUsage: tokenUsage,
      threadId: json['thread_id'] as String?,
      isThreadComplete: isThreadComplete,
      updatedEntities: updatedEntities,
      newPrompt: newPrompt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'entities': entities.map((e) => e.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
      if (tokenUsage != null) 'token_usage': tokenUsage,
      if (threadId != null) 'thread_id': threadId,
      'is_thread_complete': isThreadComplete,
      'updated_entities': updatedEntities,
      if (newPrompt != null) 'new_prompt': newPrompt,
    };
  }

  Message copyWith({
    String? id,
    String? content,
    MessageType? type,
    List<Entity>? entities,
    DateTime? timestamp,
    Map<String, dynamic>? tokenUsage,
    String? threadId,
    bool? isThreadComplete,
    Map<String, int>? updatedEntities,
    String? newPrompt,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      entities: entities ?? this.entities,
      timestamp: timestamp ?? this.timestamp,
      tokenUsage: tokenUsage ?? this.tokenUsage,
      threadId: threadId ?? this.threadId,
      isThreadComplete: isThreadComplete ?? this.isThreadComplete,
      updatedEntities: updatedEntities ?? this.updatedEntities,
      newPrompt: newPrompt ?? this.newPrompt,
    );
  }
}