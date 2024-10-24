// chat/widgets/message_bubble.dart
import 'package:flutter/material.dart';
import '../domain/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: message.type == MessageType.system
            ? Colors.grey.shade200
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (message.tokenUsage != null) ...[
            const SizedBox(height: 8),
            Text(
              'Tokens: ${message.tokenUsage!["total"]}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
