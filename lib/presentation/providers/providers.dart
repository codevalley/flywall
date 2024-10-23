import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/data/datasources/remote/topic_remote_datasource.dart';
import 'package:flywall/data/repositories/topic_repository_impl.dart';
import 'package:flywall/domain/repositories/topic_repository.dart';
import 'package:flywall/domain/usecases/topic/get_topics_usecase.dart';
import 'package:flywall/presentation/providers/topic/topic_notifier.dart';
import 'package:flywall/presentation/providers/topic/topic_state.dart';
import 'package:flywall/core/network/api_client.dart';
import 'package:flywall/data/datasources/remote/task_remote_datasource.dart';
import 'package:flywall/data/repositories/task_repository_impl.dart';
import 'package:flywall/domain/repositories/task_repository.dart';
import 'package:flywall/domain/usecases/task/get_tasks_usecase.dart';
import 'package:flywall/presentation/providers/task/task_notifier.dart';
import 'package:flywall/presentation/providers/task/task_state.dart';
import 'package:flywall/data/datasources/remote/note_remote_datasource.dart';
import 'package:flywall/data/repositories/note_repository_impl.dart';
import 'package:flywall/domain/repositories/note_repository.dart';
import 'package:flywall/domain/usecases/note/get_notes_usecase.dart';
import 'package:flywall/presentation/providers/note/note_notifier.dart';
import 'package:flywall/presentation/providers/note/note_state.dart';
import 'package:flywall/data/datasources/remote/person_remote_datasource.dart';
import 'package:flywall/data/repositories/person_repository_impl.dart';
import 'package:flywall/domain/repositories/people_repository.dart';
import 'package:flywall/domain/usecases/people/get_people_usecase.dart';
import 'package:flywall/presentation/providers/person/person_notifier.dart';
import 'package:flywall/presentation/providers/person/person_state.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

final topicRemoteDataSourceProvider = Provider<ITopicRemoteDataSource>((ref) {
  return TopicRemoteDataSource(ref.watch(apiClientProvider));
});

final topicRepositoryProvider = Provider<ITopicRepository>((ref) {
  return TopicRepositoryImpl(ref.watch(topicRemoteDataSourceProvider));
});

final getTopicsUseCaseProvider = Provider<GetTopicsUseCase>((ref) {
  return GetTopicsUseCase(ref.watch(topicRepositoryProvider));
});

final topicNotifierProvider =
    StateNotifierProvider<TopicNotifier, TopicState>((ref) {
  return TopicNotifier(ref.watch(getTopicsUseCaseProvider));
});

final taskRemoteDataSourceProvider = Provider<ITaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource(ref.watch(apiClientProvider));
});

final taskRepositoryProvider = Provider<ITaskRepository>((ref) {
  return TaskRepositoryImpl(ref.watch(taskRemoteDataSourceProvider));
});

final getTasksUseCaseProvider = Provider<GetTasksUseCase>((ref) {
  return GetTasksUseCase(ref.watch(taskRepositoryProvider));
});

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier(ref.watch(getTasksUseCaseProvider));
});

final noteRemoteDataSourceProvider = Provider<INoteRemoteDataSource>((ref) {
  return NoteRemoteDataSource(ref.watch(apiClientProvider));
});

final noteRepositoryProvider = Provider<INoteRepository>((ref) {
  return NoteRepositoryImpl(ref.watch(noteRemoteDataSourceProvider));
});

final getNotesUseCaseProvider = Provider<GetNotesUseCase>((ref) {
  return GetNotesUseCase(ref.watch(noteRepositoryProvider));
});

final noteNotifierProvider =
    StateNotifierProvider<NoteNotifier, NoteState>((ref) {
  return NoteNotifier(ref.watch(getNotesUseCaseProvider));
});

final personRemoteDataSourceProvider = Provider<IPersonRemoteDataSource>((ref) {
  return PersonRemoteDataSource(ref.watch(apiClientProvider));
});

final personRepositoryProvider = Provider<IPeopleRepository>((ref) {
  return PersonRepositoryImpl(ref.watch(personRemoteDataSourceProvider));
});

final getPeopleUseCaseProvider = Provider<GetPeopleUseCase>((ref) {
  return GetPeopleUseCase(ref.watch(personRepositoryProvider));
});

final personNotifierProvider =
    StateNotifierProvider<PersonNotifier, PersonState>((ref) {
  return PersonNotifier(ref.watch(getPeopleUseCaseProvider));
});

// Add similar providers for people and notes

