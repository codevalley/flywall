import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/note/note.dart';

abstract class INoteRepository {
  Future<Either<Failure, List<Note>>> getNotes({
    int page = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, Note>> createNote(Note note);

  Future<Either<Failure, Note>> updateNote(String id, Note note);

  Future<Either<Failure, Unit>> deleteNote(String id);
}
