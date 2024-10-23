import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/people/person.dart';

abstract class IPeopleRepository {
  Future<Either<Failure, List<Person>>> getPeople({
    int page = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, Person>> createPerson(Person person);

  Future<Either<Failure, Person>> updatePerson(String id, Person person);

  Future<Either<Failure, Unit>> deletePerson(String id);
}
