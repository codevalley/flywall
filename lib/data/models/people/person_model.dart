import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flywall/domain/entities/people/person.dart';

part 'person_model.freezed.dart';
part 'person_model.g.dart';

@freezed
class PersonModel with _$PersonModel {
  const PersonModel._();

  const factory PersonModel({
    required String id,
    required String name,
    String? email,
    String? phoneNumber,
    required List<String> relatedTopics,
    required List<String> relatedTasks,
  }) = _PersonModel;

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);

  factory PersonModel.fromDomain(Person person) => PersonModel(
        id: person.id,
        name: person.name,
        email: person.email,
        phoneNumber: person.phoneNumber,
        relatedTopics: person.relatedTopics,
        relatedTasks: person.relatedTasks,
      );

  Person toDomain() => Person(
        id: id,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        relatedTopics: relatedTopics,
        relatedTasks: relatedTasks,
      );
}
