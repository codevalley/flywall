import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/sidekick/message.dart';

abstract class ISidekickRepository {
  Future<Either<Failure, Message>> sendMessage(
    String userInput,
    String? threadId,
  );

  Future<Either<Failure, List<Message>>> getConversation(String threadId);

  Stream<Message> connectToWebSocket(String clientId);
}
