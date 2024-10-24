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

  const Message({
    required this.id,
    required this.content,
    required this.type,
    this.entities = const [],
    required this.timestamp,
    this.tokenUsage,
    this.threadId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (t) => t.name == json['type'] as String,
        orElse: () => MessageType.text,
      ),
      entities: (json['entities'] as List?)
              ?.map((e) => Entity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      timestamp: DateTime.parse(json['timestamp'] as String),
      tokenUsage: json['token_usage'] as Map<String, dynamic>?,
      threadId: json['thread_id'] as String?,
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
    };
  }
}
