import 'package:flutter/foundation.dart';

enum EntityType { task, note, person, topic }

abstract class EntityBase {
  final String id;
  final EntityType type;
  final String title;
  final DateTime timestamp;
  final List<String> tags;

  const EntityBase({
    required this.id,
    required this.type,
    required this.title,
    required this.timestamp,
    this.tags = const [],
  });

  // Abstract method that each entity must implement
  Map<String, dynamic> toJson();

  // Helper methods that can be used by all entities
  @protected
  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        try {
          return DateTime.fromMillisecondsSinceEpoch(int.parse(value));
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  @protected
  static List<String> parseTags(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) return [value];
    return [];
  }
}
