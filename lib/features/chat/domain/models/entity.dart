enum EntityType { task, note, person, topic }

class Entity {
  final String id;
  final EntityType type;
  final String title;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final List<String> tags;

  const Entity({
    required this.id,
    required this.type,
    required this.title,
    required this.data,
    required this.timestamp,
    this.tags = const [],
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    try {
      return Entity(
        id: json['id']?.toString() ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        type: EntityType.values.firstWhere(
          (e) =>
              e.name.toLowerCase() == (json['type'] as String?)?.toLowerCase(),
          orElse: () => EntityType.task,
        ),
        title: json['title']?.toString() ?? 'Untitled',
        data: _sanitizeData(json['data']),
        timestamp: _parseDateTime(json['timestamp']) ?? DateTime.now(),
        tags: _parseTags(json['tags']),
      );
    } catch (e, stackTrace) {
      print('Error parsing Entity from JSON: $e\n$stackTrace');
      // Return a default entity if parsing fails
      return Entity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: EntityType.task,
        title: 'Error: Invalid Entity',
        data: {'error': e.toString()},
        timestamp: DateTime.now(),
        tags: const [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'id': id,
        'type': type.name,
        'title': title,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
        'tags': tags,
      };
    } catch (e) {
      print('Error converting Entity to JSON: $e');
      return {
        'id': id,
        'type': type.name,
        'title': title,
        'data': {},
        'timestamp': DateTime.now().toIso8601String(),
        'tags': [],
      };
    }
  }

  // Helper method to safely parse DateTime
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        try {
          // Try parsing timestamp as milliseconds since epoch
          return DateTime.fromMillisecondsSinceEpoch(int.parse(value));
        } catch (_) {
          return null;
        }
      }
    }
    if (value is int) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // Helper method to safely parse tags
  static List<String> _parseTags(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .where((element) => element != null)
          .map((element) => element.toString())
          .toList();
    }
    if (value is String) {
      return [value];
    }
    return [];
  }

  // Helper method to sanitize data map
  static Map<String, dynamic> _sanitizeData(dynamic value) {
    if (value == null) return {};
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value.map((key, value) {
        // Convert null values to empty strings or appropriate defaults
        if (value == null) return MapEntry(key, '');
        if (value is Map) {
          return MapEntry(key, _sanitizeData(value));
        }
        if (value is List) {
          return MapEntry(key, _sanitizeList(value));
        }
        return MapEntry(key, value);
      }));
    }
    return {};
  }

  // Helper method to sanitize lists in data
  static List<dynamic> _sanitizeList(List list) {
    return list.map((item) {
      if (item == null) return '';
      if (item is Map) return _sanitizeData(item);
      if (item is List) return _sanitizeList(item);
      return item;
    }).toList();
  }

  // Convenience method to get a safely typed value from data
  T? getValue<T>(String key) {
    final value = data[key];
    if (value is T) return value;
    return null;
  }

  // Helper method to get a string value with a default
  String getStringValue(String key, {String defaultValue = ''}) {
    final value = data[key];
    if (value == null) return defaultValue;
    return value.toString();
  }

  // Helper method to check if a key exists and has a non-null value
  bool hasValue(String key) {
    return data.containsKey(key) && data[key] != null;
  }

  @override
  String toString() {
    return 'Entity{id: $id, type: $type, title: $title, timestamp: $timestamp, tags: $tags}';
  }

  // Create a copy of the entity with updated fields
  Entity copyWith({
    String? id,
    EntityType? type,
    String? title,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    List<String>? tags,
  }) {
    return Entity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      data: data ?? Map<String, dynamic>.from(this.data),
      timestamp: timestamp ?? this.timestamp,
      tags: tags ?? List<String>.from(this.tags),
    );
  }

  // Helper to create an empty entity of a specific type
  factory Entity.empty(EntityType type) {
    return Entity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      title: 'New ${type.name}',
      data: {},
      timestamp: DateTime.now(),
      tags: [],
    );
  }
}
