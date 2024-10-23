import 'package:flywall/core/network/api_client.dart';
import 'package:flywall/data/models/people/person_model.dart';
import 'package:flywall/domain/entities/people/person.dart';

abstract class IPersonRemoteDataSource {
  Future<List<PersonModel>> getPeople({int page = 1, int pageSize = 10});
  Future<PersonModel> createPerson(Person person);
  Future<PersonModel> updatePerson(String id, Person person);
  Future<void> deletePerson(String id);
}

class PersonRemoteDataSource implements IPersonRemoteDataSource {
  final ApiClient apiClient;

  PersonRemoteDataSource(this.apiClient);

  @override
  Future<List<PersonModel>> getPeople({int page = 1, int pageSize = 10}) async {
    final response = await apiClient.get<List<dynamic>>(
      '/people',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return response.map((json) => PersonModel.fromJson(json)).toList();
  }

  @override
  Future<PersonModel> createPerson(Person person) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/people',
      data: PersonModel.fromDomain(person).toJson(),
    );
    return PersonModel.fromJson(response);
  }

  @override
  Future<PersonModel> updatePerson(String id, Person person) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '/people/$id',
      data: PersonModel.fromDomain(person).toJson(),
    );
    return PersonModel.fromJson(response);
  }

  @override
  Future<void> deletePerson(String id) async {
    await apiClient.delete('/people/$id');
  }
}
