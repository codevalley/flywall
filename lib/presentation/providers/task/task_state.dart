import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flywall/domain/entities/task/task.dart';
import 'package:flywall/core/errors/failures.dart';

part 'task_state.freezed.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState.initial() = _Initial;
  const factory TaskState.loading() = _Loading;
  const factory TaskState.loaded(List<Task> tasks) = _Loaded;
  const factory TaskState.error(Failure failure) = _Error;
}
