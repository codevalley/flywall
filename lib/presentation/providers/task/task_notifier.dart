import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/domain/usecases/task/get_tasks_usecase.dart';
import 'package:flywall/presentation/providers/task/task_state.dart';

class TaskNotifier extends StateNotifier<TaskState> {
  final GetTasksUseCase _getTasksUseCase;

  TaskNotifier(this._getTasksUseCase) : super(const TaskState.initial());

  Future<void> getTasks({int page = 1, int pageSize = 10}) async {
    state = const TaskState.loading();
    final result =
        await _getTasksUseCase.execute(page: page, pageSize: pageSize);
    state = result.fold(
      (failure) => TaskState.error(failure),
      (tasks) => TaskState.loaded(tasks),
    );
  }
}
