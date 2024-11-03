import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/entity_base.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';

// State provider for tracking the currently selected entity
final selectedEntityProvider = StateProvider<EntityBase?>((ref) => null);

// Action states
final entityActionsLoadingProvider = StateProvider<bool>((ref) => false);
final entityActionsErrorProvider = StateProvider<String?>((ref) => null);

// Entity actions provider with API client
final entityActionsProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EntityActions(apiClient);
});

class EntityActions {
  final ApiClient _apiClient;

  EntityActions(this._apiClient);

  Future<void> completeTask(String taskId) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.sidekickEndpoint}/tasks/$taskId/complete',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to complete task: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error completing task: $e');
    }
  }

  Future<void> editNote(String noteId, String content) async {
    try {
      final response = await _apiClient.put(
        '${AppConfig.sidekickEndpoint}/notes/$noteId',
        data: {'content': content},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to edit note: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error editing note: $e');
    }
  }

  Future<void> addPersonToTeam(String personId) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.sidekickEndpoint}/people/$personId/team',
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to add person to team: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error adding person to team: $e');
    }
  }

  Future<void> createTaskFromTopic(String topicId) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.sidekickEndpoint}/topics/$topicId/task',
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to create task from topic: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error creating task from topic: $e');
    }
  }
}
