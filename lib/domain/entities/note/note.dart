class Note {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> relatedTopics;
  final List<String> relatedPeople;

  const Note({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.relatedTopics,
    required this.relatedPeople,
  });
}
