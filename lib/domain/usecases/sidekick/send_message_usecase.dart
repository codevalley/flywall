import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/sidekick/message.dart';
import 'package:flywall/domain/repositories/sidekick_repository.dart';

class SendMessageUseCase {
  final ISidekickRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, Message>> execute(String userInput, String? threadId) {
    return repository.sendMessage(userInput, threadId);
  }
}
