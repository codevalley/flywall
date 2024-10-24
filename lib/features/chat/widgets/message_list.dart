// chat/widgets/message_list.dart
import 'package:flutter/material.dart';
import '../domain/models/message.dart';
import 'message_bubble.dart';
import 'entity_card.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollController;

  const MessageList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageBubble(message: message),
            if (message.entities.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.entities
                    .map((entity) => EntityCard(entity: entity))
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
