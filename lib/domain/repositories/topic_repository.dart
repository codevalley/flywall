import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/topic/topic.dart';

abstract class ITopicRepository {
  Future<Either<Failure, List<Topic>>> getTopics({
    int page = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, Topic>> createTopic(Topic topic);

  Future<Either<Failure, Topic>> updateTopic(String id, Topic topic);

  Future<Either<Failure, Unit>> deleteTopic(String id);
}
