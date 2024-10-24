class Message {
  final String content;
  final String threadId;
  final List<EntityUpdate> entityUpdates;
  final TokenUsage tokenUsage;

  const Message({
    required this.content,
    required this.threadId,
    required this.entityUpdates,
    required this.tokenUsage,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] as String,
      threadId: json['thread_id'] as String,
      entityUpdates: (json['entity_updates'] as List)
          .map((e) => EntityUpdate.fromJson(e))
          .toList(),
      tokenUsage: TokenUsage.fromJson(json['token_usage']),
    );
  }
}

class EntityUpdate {
  final String type;
  final int count;

  const EntityUpdate({required this.type, required this.count});

  factory EntityUpdate.fromJson(Map<String, dynamic> json) {
    return EntityUpdate(
      type: json['type'] as String,
      count: json['count'] as int,
    );
  }
}

class TokenUsage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  const TokenUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory TokenUsage.fromJson(Map<String, dynamic> json) {
    return TokenUsage(
      promptTokens: json['prompt_tokens'] as int,
      completionTokens: json['completion_tokens'] as int,
      totalTokens: json['total_tokens'] as int,
    );
  }
}
