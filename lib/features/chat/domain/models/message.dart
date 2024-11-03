import 'entity_base.dart';
import 'entity_factory.dart';

enum MessageType { text, entity, system }

class Message {
  final String id;
  final String content;
  final MessageType type;
  final List<EntityBase> entities; // Changed from Entity to EntityBase
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
      final id = json['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString();

      final content =
          json['response']?.toString() ?? json['content']?.toString() ?? '';

      // Parse entities using the new EntityFactory
      final entities = <EntityBase>[];
      if (json['entities'] is Map<String, dynamic>) {
        final entitiesMap = json['entities'] as Map<String, dynamic>;

        // Helper function to process each entity type
        void processEntities(String key, EntityType type) {
          if (entitiesMap[key] is List) {
            for (final item in entitiesMap[key]) {
              try {
                if (item is Map<String, dynamic>) {
                  // Prepare the entity data with proper ID field and type
                  final entityData = Map<String, dynamic>.from(item);
                  entityData['id'] = item['${type.name}_id']?.toString() ??
                      DateTime.now().microsecondsSinceEpoch.toString();
                  entityData['type'] = type.name;

                  // Use EntityFactory to create the appropriate entity type
                  entities.add(EntityFactory.fromJson(entityData));
                }
              } catch (e) {
                print('Error parsing ${type.name}: $e');
              }
            }
          }
        }

        // Process each entity type
        processEntities('tasks', EntityType.task);
        processEntities('notes', EntityType.note);
        processEntities('people', EntityType.person);
        processEntities('topics', EntityType.topic);
      }

      // Parse token usage
      Map<String, dynamic>? tokenUsage;
      if (json['token_usage'] is Map) {
        tokenUsage = Map<String, dynamic>.from(json['token_usage'] as Map);
      }

      // Parse updated entities counts
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
    List<EntityBase>? entities, // Changed from Entity to EntityBase
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

  @override
  String toString() {
    return 'Message{id: $id, content: $content, type: $type, '
        'entities: ${entities.length}, timestamp: $timestamp, '
        'threadId: $threadId, isThreadComplete: $isThreadComplete}';
  }
}
