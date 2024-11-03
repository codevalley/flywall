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

// Factory constructor for base deserialization
  static EntityBase fromJson(Map<String, dynamic> json) {
    // This will be implemented by EntityFactory
    throw UnimplementedError('Use EntityFactory.fromJson() instead');
  }

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

  @protected
  static Map<String, dynamic> sanitizeData(dynamic value) {
    if (value == null) return {};
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value.map((key, value) {
        if (value == null) return MapEntry(key, '');
        if (value is Map) return MapEntry(key, sanitizeData(value));
        if (value is List) return MapEntry(key, sanitizeList(value));
        return MapEntry(key, value);
      }));
    }
    return {};
  }

  @protected
  static List<dynamic> sanitizeList(List list) {
    return list.map((item) {
      if (item == null) return '';
      if (item is Map) return sanitizeData(item);
      if (item is List) return sanitizeList(item);
      return item;
    }).toList();
  }
}
