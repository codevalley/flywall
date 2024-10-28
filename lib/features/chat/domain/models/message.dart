// lib/features/chat/domain/models/message.dart

import 'entity.dart';

enum MessageType { text, entity, system }

class Message {
  final String id;
  final String content;
  final MessageType type;
  final List<Entity> entities;
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
    try {
      // Generate a unique message ID if none provided
      final id = json['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString();

      // Use 'response' field as content, falling back to 'content' if not present
      final content =
          json['response']?.toString() ?? json['content']?.toString() ?? '';

      // Parse entities from the new structure
      final entities = <Entity>[];
      if (json['entities'] is Map<String, dynamic>) {
        final entitiesMap = json['entities'] as Map<String, dynamic>;

        // Process tasks
        if (entitiesMap['tasks'] is List) {
          for (final task in entitiesMap['tasks']) {
            try {
              if (task is Map<String, dynamic>) {
                entities.add(Entity(
                  id: task['task_id']?.toString() ??
                      DateTime.now().microsecondsSinceEpoch.toString(),
                  type: EntityType.task,
                  title: task['title']?.toString() ?? 'Untitled Task',
                  data: Map<String, dynamic>.from(task),
                  timestamp:
                      DateTime.tryParse(task['created_at']?.toString() ?? '') ??
                          DateTime.now(),
                ));
              }
            } catch (e) {
              print('Error parsing task: $e');
            }
          }
        }

        // Process notes
        if (entitiesMap['notes'] is List) {
          for (final note in entitiesMap['notes']) {
            try {
              if (note is Map<String, dynamic>) {
                entities.add(Entity(
                  id: note['note_id']?.toString() ??
                      DateTime.now().microsecondsSinceEpoch.toString(),
                  type: EntityType.note,
                  title: note['content']?.toString() ?? 'Untitled Note',
                  data: Map<String, dynamic>.from(note),
                  timestamp:
                      DateTime.tryParse(note['created_at']?.toString() ?? '') ??
                          DateTime.now(),
                ));
              }
            } catch (e) {
              print('Error parsing note: $e');
            }
          }
        }

        // Process people
        if (entitiesMap['people'] is List) {
          for (final person in entitiesMap['people']) {
            try {
              if (person is Map<String, dynamic>) {
                entities.add(Entity(
                  id: person['person_id']?.toString() ??
                      DateTime.now().microsecondsSinceEpoch.toString(),
                  type: EntityType.person,
                  title: person['name']?.toString() ??
                      person['screen_name']?.toString() ??
                      'Unnamed Person',
                  data: Map<String, dynamic>.from(person),
                  timestamp: DateTime.tryParse(
                          person['created_at']?.toString() ?? '') ??
                      DateTime.now(),
                ));
              }
            } catch (e) {
              print('Error parsing person: $e');
            }
          }
        }

        // Process topics
        if (entitiesMap['topics'] is List) {
          for (final topic in entitiesMap['topics']) {
            try {
              if (topic is Map<String, dynamic>) {
                entities.add(Entity(
                  id: topic['topic_id']?.toString() ??
                      DateTime.now().microsecondsSinceEpoch.toString(),
                  type: EntityType.topic,
                  title: topic['name']?.toString() ?? 'Untitled Topic',
                  data: Map<String, dynamic>.from(topic),
                  timestamp: DateTime.tryParse(
                          topic['created_at']?.toString() ?? '') ??
                      DateTime.now(),
                ));
              }
            } catch (e) {
              print('Error parsing topic: $e');
            }
          }
        }
      }

      // Parse token usage safely
      Map<String, dynamic>? tokenUsage;
      if (json['token_usage'] is Map) {
        tokenUsage = Map<String, dynamic>.from(json['token_usage'] as Map);
      }

      // Parse updated entities safely
      final updatedEntities = <String, int>{};
      if (json['updated_entities'] is Map) {
        final updateMap = json['updated_entities'] as Map;
        for (final entry in updateMap.entries) {
          try {
            updatedEntities[entry.key.toString()] =
                int.tryParse(entry.value.toString()) ?? 0;
          } catch (e) {
            print('Error parsing updated entity count: $e');
          }
        }
      }

      return Message(
        id: id,
        content: content,
        type: MessageType.values.firstWhere(
          (t) => t.name == (json['type'] as String?)?.toLowerCase(),
          orElse: () => MessageType.text,
        ),
        entities: entities,
        timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
            DateTime.now(),
        tokenUsage: tokenUsage,
        threadId: json['thread_id']?.toString(),
        isThreadComplete: json['is_thread_complete'] as bool? ?? false,
        updatedEntities: updatedEntities,
        newPrompt: json['new_prompt']?.toString(),
      );
    } catch (e, stackTrace) {
      print('Error parsing Message: $e');
      print('Stack trace: $stackTrace');

      // Return a default error message if parsing fails
      return Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        content: 'Error parsing message: $e',
        type: MessageType.system,
        timestamp: DateTime.now(),
        isThreadComplete: false,
      );
    }
  }

  Map<String, dynamic> toJson() {
    try {
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
    } catch (e) {
      print('Error converting Message to JSON: $e');
      return {
        'id': id,
        'content': content,
        'type': type.name,
        'timestamp': timestamp.toIso8601String(),
        'is_thread_complete': isThreadComplete,
      };
    }
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
