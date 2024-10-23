class Topic {
  final String id;
  final String name;
  final String description;
  final List<String> keywords;
  final List<String> relatedPeople;
  final List<String> relatedTasks;

  const Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.keywords,
    required this.relatedPeople,
    required this.relatedTasks,
  });
}
