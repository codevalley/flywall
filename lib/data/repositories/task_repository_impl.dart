import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/exceptions.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/data/datasources/remote/task_remote_datasource.dart';
import 'package:flywall/domain/entities/task/task.dart' as task_entity;
import 'package:flywall/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final ITaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<task_entity.Task>>> getTasks({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final taskModels =
          await remoteDataSource.getTasks(page: page, pageSize: pageSize);
      final tasks = taskModels.map((model) => model.toDomain()).toList();
      return Right(tasks);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, task_entity.Task>> createTask(
      task_entity.Task task) async {
    try {
      final taskModel = await remoteDataSource.createTask(task);
      return Right(taskModel.toDomain());
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, task_entity.Task>> updateTask(
      String id, task_entity.Task task) async {
    try {
      final taskModel = await remoteDataSource.updateTask(id, task);
      return Right(taskModel.toDomain());
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }
}
