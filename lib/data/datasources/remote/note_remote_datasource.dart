import 'package:flywall/core/network/api_client.dart';
import 'package:flywall/data/models/note/note_model.dart';
import 'package:flywall/domain/entities/note/note.dart';

abstract class INoteRemoteDataSource {
  Future<List<NoteModel>> getNotes({int page = 1, int pageSize = 10});
  Future<NoteModel> createNote(Note note);
  Future<NoteModel> updateNote(String id, Note note);
  Future<void> deleteNote(String id);
}

class NoteRemoteDataSource implements INoteRemoteDataSource {
  final ApiClient apiClient;

  NoteRemoteDataSource(this.apiClient);

  @override
  Future<List<NoteModel>> getNotes({int page = 1, int pageSize = 10}) async {
    final response = await apiClient.get<List<dynamic>>(
      '/notes',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return response.map((json) => NoteModel.fromJson(json)).toList();
  }

  @override
  Future<NoteModel> createNote(Note note) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/notes',
      data: NoteModel.fromDomain(note).toJson(),
    );
    return NoteModel.fromJson(response);
  }

  @override
  Future<NoteModel> updateNote(String id, Note note) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '/notes/$id',
      data: NoteModel.fromDomain(note).toJson(),
    );
    return NoteModel.fromJson(response);
  }

  @override
  Future<void> deleteNote(String id) async {
    await apiClient.delete('/notes/$id');
  }
}
