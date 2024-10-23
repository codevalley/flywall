import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flywall/domain/entities/note/note.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
class NoteModel with _$NoteModel {
  const NoteModel._();

  const factory NoteModel({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> relatedTopics,
    required List<String> relatedPeople,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  factory NoteModel.fromDomain(Note note) => NoteModel(
        id: note.id,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        relatedTopics: note.relatedTopics,
        relatedPeople: note.relatedPeople,
      );

  Note toDomain() => Note(
        id: id,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
        relatedTopics: relatedTopics,
        relatedPeople: relatedPeople,
      );
}
