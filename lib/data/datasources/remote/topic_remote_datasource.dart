import 'package:flywall/core/network/api_client.dart';
import 'package:flywall/data/models/topic/topic_model.dart';
import 'package:flywall/domain/entities/topic/topic.dart';

abstract class ITopicRemoteDataSource {
  Future<List<TopicModel>> getTopics({int page = 1, int pageSize = 10});
  Future<TopicModel> createTopic(Topic topic);
  Future<TopicModel> updateTopic(String id, Topic topic);
  Future<void> deleteTopic(String id);
}

class TopicRemoteDataSource implements ITopicRemoteDataSource {
  final ApiClient apiClient;

  TopicRemoteDataSource(this.apiClient);

  @override
  Future<List<TopicModel>> getTopics({int page = 1, int pageSize = 10}) async {
    final response = await apiClient.get<List<dynamic>>(
      '/topics',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return response.map((json) => TopicModel.fromJson(json)).toList();
  }

  @override
  Future<TopicModel> createTopic(Topic topic) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/topics',
      data: TopicModel.fromDomain(topic).toJson(),
    );
    return TopicModel.fromJson(response);
  }

  @override
  Future<TopicModel> updateTopic(String id, Topic topic) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '/topics/$id',
      data: TopicModel.fromDomain(topic).toJson(),
    );
    return TopicModel.fromJson(response);
  }

  @override
  Future<void> deleteTopic(String id) async {
    await apiClient.delete('/topics/$id');
  }
}
