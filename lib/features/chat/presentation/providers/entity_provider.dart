// lib/features/chat/presentation/providers/entity_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/entity.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';

// State provider for tracking the currently selected entity
final selectedEntityProvider = StateProvider<Entity?>((ref) => null);

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
      await _apiClient.post(
        '${AppConfig.sidekickEndpoint}/tasks/$taskId/complete',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editNote(String noteId, String content) async {
    try {
      await _apiClient.put(
        '${AppConfig.sidekickEndpoint}/notes/$noteId',
        data: {'content': content},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPersonToTeam(String personId) async {
    try {
      await _apiClient.post(
        '${AppConfig.sidekickEndpoint}/people/$personId/team',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTaskFromTopic(String topicId) async {
    try {
      await _apiClient.post(
        '${AppConfig.sidekickEndpoint}/topics/$topicId/task',
      );
    } catch (e) {
      rethrow;
    }
  }
}
