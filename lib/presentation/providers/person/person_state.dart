import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flywall/domain/entities/people/person.dart';
import 'package:flywall/core/errors/failures.dart';

part 'person_state.freezed.dart';

@freezed
class PersonState with _$PersonState {
  const factory PersonState.initial() = _Initial;
  const factory PersonState.loading() = _Loading;
  const factory PersonState.loaded(List<Person> people) = _Loaded;
  const factory PersonState.error(Failure failure) = _Error;
}
