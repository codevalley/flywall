import 'package:flywall/core/network/api_client.dart';
import 'package:flywall/data/models/task/task_model.dart';
import 'package:flywall/domain/entities/task/task.dart';

abstract class ITaskRemoteDataSource {
  Future<List<TaskModel>> getTasks({int page = 1, int pageSize = 10});
  Future<TaskModel> createTask(Task task);
  Future<TaskModel> updateTask(String id, Task task);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSource implements ITaskRemoteDataSource {
  final ApiClient apiClient;

  TaskRemoteDataSource(this.apiClient);

  @override
  Future<List<TaskModel>> getTasks({int page = 1, int pageSize = 10}) async {
    final response = await apiClient.get<List<dynamic>>(
      '/tasks',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return response.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<TaskModel> createTask(Task task) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/tasks',
      data: TaskModel.fromDomain(task).toJson(),
    );
    return TaskModel.fromJson(response);
  }

  @override
  Future<TaskModel> updateTask(String id, Task task) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '/tasks/$id',
      data: TaskModel.fromDomain(task).toJson(),
    );
    return TaskModel.fromJson(response);
  }

  @override
  Future<void> deleteTask(String id) async {
    await apiClient.delete('/tasks/$id');
  }
}
