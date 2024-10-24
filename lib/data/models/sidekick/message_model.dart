import 'package:flywall/domain/entities/sidekick/message.dart';

class MessageModel {
  final String content;
  final String threadId;
  final List<EntityUpdateModel> entityUpdates;
  final TokenUsageModel tokenUsage;

  MessageModel({
    required this.content,
    required this.threadId,
    required this.entityUpdates,
    required this.tokenUsage,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        content: json['content'],
        threadId: json['thread_id'],
        entityUpdates: (json['entity_updates'] as List)
            .map((e) => EntityUpdateModel.fromJson(e))
            .toList(),
        tokenUsage: TokenUsageModel.fromJson(json['token_usage']),
      );

  Message toDomain() => Message(
        content: content,
        threadId: threadId,
        entityUpdates: entityUpdates.map((e) => e.toDomain()).toList(),
        tokenUsage: tokenUsage.toDomain(),
      );
}

class EntityUpdateModel {
  final String type;
  final int count;

  EntityUpdateModel({required this.type, required this.count});

  factory EntityUpdateModel.fromJson(Map<String, dynamic> json) =>
      EntityUpdateModel(
        type: json['type'],
        count: json['count'],
      );

  EntityUpdate toDomain() => EntityUpdate(type: type, count: count);
}

class TokenUsageModel {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  TokenUsageModel({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory TokenUsageModel.fromJson(Map<String, dynamic> json) =>
      TokenUsageModel(
        promptTokens: json['prompt_tokens'],
        completionTokens: json['completion_tokens'],
        totalTokens: json['total_tokens'],
      );

  TokenUsage toDomain() => TokenUsage(
        promptTokens: promptTokens,
        completionTokens: completionTokens,
        totalTokens: totalTokens,
      );
}
