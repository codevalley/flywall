class Message {
  final String id;
  final String threadId;
  final String content;
  final List<EntityUpdate> entityUpdates;
  final TokenUsage tokenUsage;

  const Message({
    required this.id,
    required this.threadId,
    required this.content,
    required this.entityUpdates,
    required this.tokenUsage,
  });
}

class EntityUpdate {
  final String type;
  final int count;

  const EntityUpdate({required this.type, required this.count});
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
}
