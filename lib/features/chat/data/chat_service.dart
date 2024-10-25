import '../../../core/network/api_client.dart';
import '../../../core/config/app_config.dart';
import '../domain/models/message.dart';

class ChatService {
  final ApiClient _apiClient;

  ChatService(this._apiClient);

  Future<Message> sendMessage(String input, {String? threadId}) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.sidekickEndpoint}/ask',
        data: {
          'user_input': input,
          if (threadId != null) 'thread_id': threadId,
        },
      );

      return Message.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Message>> getThread(String threadId) async {
    try {
      final response = await _apiClient.get(
        '${AppConfig.sidekickEndpoint}/conversation/$threadId',
      );

      return (response.data as List)
          .map((json) => Message.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
