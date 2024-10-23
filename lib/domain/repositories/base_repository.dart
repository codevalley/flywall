import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';

abstract class BaseRepository<T> {
  Future<Either<Failure, T>> get(String id);
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, T>> create(T entity);
  Future<Either<Failure, T>> update(T entity);
  Future<Either<Failure, Unit>> delete(String id);
}
