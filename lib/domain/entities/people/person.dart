class Person {
  final String id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final List<String> relatedTopics;
  final List<String> relatedTasks;

  const Person({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.relatedTopics,
    required this.relatedTasks,
  });
}
