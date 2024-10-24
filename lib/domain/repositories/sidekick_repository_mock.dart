// domain/repositories/sidekick_repository_mock.dart
import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/sidekick/message.dart';
import 'package:flywall/domain/repositories/sidekick_repository.dart';

class MockSidekickRepository implements ISidekickRepository {
  @override
  Future<Either<Failure, Message>> sendMessage(
      String userInput, String? threadId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return Right(Message(
      content: 'This is a mock response to: $userInput',
      threadId: threadId ?? '1',
      entityUpdates: [const EntityUpdate(type: 'task', count: 1)],
      tokenUsage: const TokenUsage(
        promptTokens: 10,
        completionTokens: 20,
        totalTokens: 30,
      ),
    ));
  }

  @override
  Future<Either<Failure, List<Message>>> getConversation(
      String threadId) async {
    return const Right([]);
  }

  @override
  Stream<Message> connectToWebSocket(String clientId) {
    throw UnimplementedError();
  }
}
