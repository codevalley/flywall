import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/task/task.dart' as task_entity;
import 'package:flywall/domain/repositories/task_repository.dart';

class GetTasksUseCase {
  final ITaskRepository repository;

  const GetTasksUseCase(this.repository);

  Future<Either<Failure, List<task_entity.Task>>> execute({
    int page = 1,
    int pageSize = 10,
  }) {
    return repository.getTasks(page: page, pageSize: pageSize);
  }
}
