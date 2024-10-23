import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flywall/domain/entities/task/task.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String id,
    required String title,
    required String description,
    required TaskStatus status,
    required DateTime createdAt,
    DateTime? dueDate,
    required List<String> relatedTopics,
    required List<String> assignees,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  factory TaskModel.fromDomain(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        status: task.status,
        createdAt: task.createdAt,
        dueDate: task.dueDate,
        relatedTopics: task.relatedTopics,
        assignees: task.assignees,
      );

  Task toDomain() => Task(
        id: id,
        title: title,
        description: description,
        status: status,
        createdAt: createdAt,
        dueDate: dueDate,
        relatedTopics: relatedTopics,
        assignees: assignees,
      );
}
