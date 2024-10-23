import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/exceptions.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/data/datasources/remote/note_remote_datasource.dart';
import 'package:flywall/domain/entities/note/note.dart';
import 'package:flywall/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements INoteRepository {
  final INoteRemoteDataSource remoteDataSource;

  NoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Note>>> getNotes({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final noteModels =
          await remoteDataSource.getNotes(page: page, pageSize: pageSize);
      final notes = noteModels.map((model) => model.toDomain()).toList();
      return Right(notes);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote(Note note) async {
    try {
      final noteModel = await remoteDataSource.createNote(note);
      return Right(noteModel.toDomain());
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(String id, Note note) async {
    try {
      final noteModel = await remoteDataSource.updateNote(id, note);
      return Right(noteModel.toDomain());
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNote(String id) async {
    try {
      await remoteDataSource.deleteNote(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } on NetworkException catch (e) {
      return Left(Failure.network(e.message));
    }
  }
}
