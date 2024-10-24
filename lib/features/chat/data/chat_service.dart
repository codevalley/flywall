import 'package:dio/dio.dart';
import '../domain/models/message.dart';
import '../../../core/config/app_config.dart';

class ChatService {
  final Dio _dio;

  ChatService(this._dio);

  Future<Message> sendMessage(String input, {String? threadId}) async {
    try {
      final response = await _dio.post(
        '${AppConfig.apiPath}/sidekick/ask',
        data: {
          'user_input': input,
          if (threadId != null) 'thread_id': threadId,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send message: ${response.statusCode}');
      }

      return Message.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please try again.');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      }
      throw Exception(e.message ?? 'Failed to send message');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<List<Message>> getThread(String threadId) async {
    try {
      final response = await _dio.get(
        '${AppConfig.apiPath}/sidekick/conversation/$threadId',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get thread: ${response.statusCode}');
      }

      return (response.data as List)
          .map((json) => Message.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please try again.');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      }
      throw Exception(e.message ?? 'Failed to get thread');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
