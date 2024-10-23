import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flywall/domain/entities/note/note.dart';
import 'package:flywall/core/errors/failures.dart';

part 'note_state.freezed.dart';

@freezed
class NoteState with _$NoteState {
  const factory NoteState.initial() = _Initial;
  const factory NoteState.loading() = _Loading;
  const factory NoteState.loaded(List<Note> notes) = _Loaded;
  const factory NoteState.error(Failure failure) = _Error;
}
