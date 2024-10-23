import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/data/datasources/remote/topic_remote_datasource.dart';
import 'package:flywall/data/repositories/topic_repository_impl.dart';
import 'package:flywall/domain/repositories/topic_repository.dart';
import 'package:flywall/domain/usecases/topic/get_topics_usecase.dart';
import 'package:flywall/presentation/providers/topic/topic_notifier.dart';
import 'package:flywall/presentation/providers/topic/topic_state.dart';
import 'package:flywall/core/network/api_client.dart';

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
