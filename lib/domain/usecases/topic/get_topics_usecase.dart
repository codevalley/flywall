import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/topic/topic.dart';
import 'package:flywall/domain/repositories/topic_repository.dart';

class GetTopicsUseCase {
  final ITopicRepository repository;

  const GetTopicsUseCase(this.repository);

  Future<Either<Failure, List<Topic>>> execute({
    int page = 1,
    int pageSize = 10,
  }) {
    return repository.getTopics(page: page, pageSize: pageSize);
  }
}
