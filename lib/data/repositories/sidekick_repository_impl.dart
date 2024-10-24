import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/core/network/api_client.dart';
import 'package:flywall/domain/entities/sidekick/message.dart';
import 'package:flywall/domain/repositories/sidekick_repository.dart';

class SidekickRepositoryImpl implements ISidekickRepository {
  final ApiClient _apiClient;

  SidekickRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, Message>> sendMessage(
      String userInput, String? threadId) async {
    try {
      final response = await _apiClient.post('/sidekick/ask', data: {
        'user_input': userInput,
        'thread_id': threadId,
      });
      // Parse the response and return a Message entity
      return Right(Message.fromJson(response.data));
    } catch (e) {
      return Left(Failure.fromException(e as Exception));
    }
  }

  @override
  Stream<Message> connectToWebSocket(String clientId) {
    // TODO: Implement this method
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Message>>> getConversation(String threadId) {
    // TODO: Implement this method
    throw UnimplementedError();
  }
}
