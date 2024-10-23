import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/note/note.dart';
import 'package:flywall/domain/repositories/note_repository.dart';

class GetNotesUseCase {
  final INoteRepository repository;

  const GetNotesUseCase(this.repository);

  Future<Either<Failure, List<Note>>> execute({
    int page = 1,
    int pageSize = 10,
  }) {
    return repository.getNotes(page: page, pageSize: pageSize);
  }
}
