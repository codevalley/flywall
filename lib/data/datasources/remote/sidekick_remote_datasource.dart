import 'package:flywall/core/network/api_client.dart';
import 'package:flywall/data/models/sidekick/message_model.dart';

abstract class ISidekickRemoteDataSource {
  Future<MessageModel> sendMessage(String userInput, String? threadId);
  Future<List<MessageModel>> getConversation(String threadId);
}

class SidekickRemoteDataSource implements ISidekickRemoteDataSource {
  final ApiClient client;

  const SidekickRemoteDataSource(this.client);

  @override
  Future<MessageModel> sendMessage(String userInput, String? threadId) async {
    final response = await client.post(
      '/api/v1/sidekick/ask',
      data: {
        'user_input': userInput,
        'thread_id': threadId,
      },
    );

    return MessageModel.fromJson(response.data);
  }

  @override
  Future<List<MessageModel>> getConversation(String threadId) async {
    final response = await client.get(
      '/api/v1/sidekick/conversation/$threadId',
    );

    return (response.data as List)
        .map((json) => MessageModel.fromJson(json))
        .toList();
  }
}
