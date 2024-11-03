import 'entity_base.dart';

class PersonEntity extends EntityBase {
  final String personId;
  final String name;
  final String? designation;
  final String? relationType;
  final String? importance;
  final String? notes;
  final Map<String, String>? contact;

  PersonEntity({
    required this.personId,
    required this.name,
    this.designation,
    this.relationType,
    this.importance,
    this.notes,
    this.contact,
    required super.id,
    required super.timestamp,
    super.tags = const [],
  }) : super(
          type: EntityType.person,
          title: name,
        );

  factory PersonEntity.fromJson(Map<String, dynamic> json) {
    return PersonEntity(
      id: json['id'] ?? '',
      personId: json['personId'] ?? '',
      name: json['name'] ?? '',
      designation: json['designation'],
      relationType: json['relationType'],
      importance: json['importance'],
      notes: json['notes'],
      contact: json['contact'] != null
          ? Map<String, String>.from(json['contact'])
          : null,
      timestamp: EntityBase.parseDateTime(json['timestamp']) ?? DateTime.now(),
      tags: EntityBase.parseTags(json['tags']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'personId': personId,
      'name': name,
      'designation': designation,
      'relationType': relationType,
      'importance': importance,
      'notes': notes,
      'contact': contact,
      'timestamp': super.timestamp.toIso8601String(),
      'tags': super.tags,
      'type': super.type.name,
    };
  }
}
