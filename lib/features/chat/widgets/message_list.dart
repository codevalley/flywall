import 'package:flutter/material.dart';
import '../presentation/providers/chat_provider.dart';

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final bool isThreadComplete;

  const MessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.isThreadComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Reverse the messages list to show newest at the bottom
    final reversedMessages = messages.reversed.toList();

    return ListView.builder(
      controller: scrollController,
      reverse: true, // This makes the list build from bottom to top
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 20,
        bottom: 8,
      ),
      itemCount: reversedMessages.length + (isThreadComplete ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0 && isThreadComplete) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Thread complete',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ask a question to start a new thread',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final message = reversedMessages[index - (isThreadComplete ? 1 : 0)];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Align(
            alignment: message.isUserMessage
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUserMessage ? Colors.blue[100] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: message.isUserMessage ? Colors.black87 : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
