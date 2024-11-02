import 'package:flutter/material.dart';
import '../../domain/models/entity.dart';
import '../../../../core/theme/theme.dart';

class EntityCard extends StatelessWidget {
  final Entity entity;
  final VoidCallback? onTap;

  const EntityCard({
    super.key,
    required this.entity,
    this.onTap,
  });

  String _getEntityTypeText() {
    switch (entity.type) {
      case EntityType.task:
        return 'TASK';
      case EntityType.topic:
        return 'TOPIC';
      case EntityType.note:
        return 'NOTE';
      case EntityType.person:
        return 'PERSON';
      default:
        return '';
    }
  }

  String _getRelativeDate() {
    // TODO: Implement proper relative date logic
    final data = entity.data;
    if (entity.type == EntityType.task && data['due_date'] != null) {
      return 'due in a day';
    } else if (data['created_at'] != null) {
      return 'added recently';
    }
    return '';
  }

  List<String> _getStatusFields() {
    final data = entity.data;
    final List<String> fields = [];

    switch (entity.type) {
      case EntityType.task:
        if (data['priority'] != null) {
          fields.add(data['priority'].toString().toUpperCase());
        }
        if (data['status'] != null) {
          fields.add(data['status'].toString().toUpperCase());
        }
        break;
      case EntityType.person:
        if (data['relationship'] != null) {
          fields.add(data['relationship'].toString().toUpperCase());
        }
        if (data['status'] != null) {
          fields.add(data['status'].toString().toUpperCase());
        }
        break;
      default:
        break;
    }

    return fields;
  }

  @override
  Widget build(BuildContext context) {
    final statusFields = _getStatusFields();
    final relativeDate = _getRelativeDate();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 332,
        height: 140,
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Entity Type and Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getEntityIcon(),
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getEntityTypeText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Graphik',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                Transform.rotate(
                  angle: -0.79,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Content
            Text(
              entity.data['content'] ?? entity.title,
              style: const TextStyle(
                color: Color(0xFF14AE5C),
                fontSize: 18,
                fontFamily: 'Blacker Display',
                fontWeight: FontWeight.w400,
                height: 1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // Bottom Row
            if (relativeDate.isNotEmpty || statusFields.isNotEmpty)
              Row(
                children: [
                  if (relativeDate.isNotEmpty)
                    Text(
                      relativeDate,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.74),
                        fontSize: 14,
                        fontFamily: 'Graphik',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  const Spacer(),
                  ...statusFields.map((field) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          field,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.74),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }

  IconData _getEntityIcon() {
    switch (entity.type) {
      case EntityType.task:
        return Icons.check_circle_outline;
      case EntityType.topic:
        return Icons.topic;
      case EntityType.note:
        return Icons.note;
      case EntityType.person:
        return Icons.person_outline;
      default:
        return Icons.error_outline;
    }
  }
}
