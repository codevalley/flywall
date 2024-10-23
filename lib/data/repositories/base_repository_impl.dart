import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/repositories/base_repository.dart';

abstract class BaseRepositoryImpl<T> implements BaseRepository<T> {
  @override
  Future<Either<Failure, T>> get(String id) async {
    try {
      final result = await getFromDataSource(id);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<T>>> getAll() async {
    try {
      final result = await getAllFromDataSource();
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, T>> create(T entity) async {
    try {
      final result = await createInDataSource(entity);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, T>> update(T entity) async {
    try {
      final result = await updateInDataSource(entity);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await deleteFromDataSource(id);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  Future<T> getFromDataSource(String id);
  Future<List<T>> getAllFromDataSource();
  Future<T> createInDataSource(T entity);
  Future<T> updateInDataSource(T entity);
  Future<void> deleteFromDataSource(String id);
}
