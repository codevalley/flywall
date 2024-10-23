import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/domain/usecases/people/get_people_usecase.dart';
import 'package:flywall/presentation/providers/person/person_state.dart';

class PersonNotifier extends StateNotifier<PersonState> {
  final GetPeopleUseCase _getPeopleUseCase;

  PersonNotifier(this._getPeopleUseCase) : super(const PersonState.initial());

  Future<void> getPeople({int page = 1, int pageSize = 10}) async {
    state = const PersonState.loading();
    final result =
        await _getPeopleUseCase.execute(page: page, pageSize: pageSize);
    state = result.fold(
      (failure) => PersonState.error(failure),
      (people) => PersonState.loaded(people),
    );
  }
}
