import 'package:flywall/domain/entities/sidekick/message.dart';

class MessageModel {
  final String id;
  final String threadId;
  final String content;
  final Map<String, int> updatedEntities;
  final TokenUsageModel tokenUsage;

  MessageModel({
    required this.id,
    required this.threadId,
    required this.content,
    required this.updatedEntities,
    required this.tokenUsage,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'],
        threadId: json['thread_id'],
        content: json['content'],
        updatedEntities: Map<String, int>.from(json['updated_entities']),
        tokenUsage: TokenUsageModel.fromJson(json['token_usage']),
      );

  Message toDomain() => Message(
        id: id,
        threadId: threadId,
        content: content,
        entityUpdates: updatedEntities.entries
            .map((e) => EntityUpdate(type: e.key, count: e.value))
            .toList(),
        tokenUsage: tokenUsage.toDomain(),
      );
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
