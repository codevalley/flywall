import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/domain/usecases/note/get_notes_usecase.dart';
import 'package:flywall/presentation/providers/note/note_state.dart';

class NoteNotifier extends StateNotifier<NoteState> {
  final GetNotesUseCase _getNotesUseCase;

  NoteNotifier(this._getNotesUseCase) : super(const NoteState.initial());

  Future<void> getNotes({int page = 1, int pageSize = 10}) async {
    state = const NoteState.loading();
    final result =
        await _getNotesUseCase.execute(page: page, pageSize: pageSize);
    state = result.fold(
      (failure) => NoteState.error(failure),
      (notes) => NoteState.loaded(notes),
    );
  }
}
