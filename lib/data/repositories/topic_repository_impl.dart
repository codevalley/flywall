import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/exceptions.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/data/datasources/remote/topic_remote_datasource.dart';
import 'package:flywall/domain/entities/topic/topic.dart';
import 'package:flywall/domain/repositories/topic_repository.dart';

class TopicRepositoryImpl implements ITopicRepository {
  final ITopicRemoteDataSource remoteDataSource;

  TopicRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Topic>>> getTopics({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final topicModels =
          await remoteDataSource.getTopics(page: page, pageSize: pageSize);
      final topics = topicModels.map((model) => model.toDomain()).toList();
      return Right(topics);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Topic>> createTopic(Topic topic) async {
    try {
      final topicModel = await remoteDataSource.createTopic(topic);
      return Right(topicModel.toDomain());
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Topic>> updateTopic(String id, Topic topic) async {
    try {
      final topicModel = await remoteDataSource.updateTopic(id, topic);
      return Right(topicModel.toDomain());
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTopic(String id) async {
    try {
      await remoteDataSource.deleteTopic(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }
}
