import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/exceptions.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/data/datasources/remote/person_remote_datasource.dart';
import 'package:flywall/domain/entities/people/person.dart';
import 'package:flywall/domain/repositories/people_repository.dart';

class PersonRepositoryImpl implements IPeopleRepository {
  final IPersonRemoteDataSource remoteDataSource;

  PersonRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Person>>> getPeople({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final personModels =
          await remoteDataSource.getPeople(page: page, pageSize: pageSize);
      final people = personModels.map((model) => model.toDomain()).toList();
      return Right(people);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Person>> createPerson(Person person) async {
    try {
      final personModel = await remoteDataSource.createPerson(person);
      return Right(personModel.toDomain());
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Person>> updatePerson(String id, Person person) async {
    try {
      final personModel = await remoteDataSource.updatePerson(id, person);
      return Right(personModel.toDomain());
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePerson(String id) async {
    try {
      await remoteDataSource.deletePerson(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }
}
