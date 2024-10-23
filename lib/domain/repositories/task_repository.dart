import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/task/task.dart' as entity;

abstract class ITaskRepository {
  Future<Either<Failure, List<entity.Task>>> getTasks({
    int page = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, entity.Task>> createTask(entity.Task task);

  Future<Either<Failure, entity.Task>> updateTask(String id, entity.Task task);

  Future<Either<Failure, Unit>> deleteTask(String id);
}
