enum TaskStatus { todo, inProgress, done }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final List<String> relatedTopics;
  final List<String> assignees;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.dueDate,
    required this.relatedTopics,
    required this.assignees,
  });
}
