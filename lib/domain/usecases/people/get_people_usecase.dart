import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/people/person.dart';
import 'package:flywall/domain/repositories/people_repository.dart';

class GetPeopleUseCase {
  final IPeopleRepository repository;

  const GetPeopleUseCase(this.repository);

  Future<Either<Failure, List<Person>>> execute({
    int page = 1,
    int pageSize = 10,
  }) {
    return repository.getPeople(page: page, pageSize: pageSize);
  }
}
