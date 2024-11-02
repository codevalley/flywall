import 'package:flutter/material.dart';
import '../presentation/providers/chat_provider.dart';
import 'entity/entity_card.dart';
import '../domain/models/entity.dart';
import '../../../core/theme/theme.dart';

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
    final reversedMessages = messages.reversed.toList();

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: 8,
      ),
      itemCount: reversedMessages.length + (isThreadComplete ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0 && isThreadComplete) {
          return _buildThreadCompleteMessage();
        }

        final message = reversedMessages[index - (isThreadComplete ? 1 : 0)];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: message.isUserMessage
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              _buildMessageBubble(context, message),
              if (!message.isUserMessage) ...[
                const SizedBox(height: 4),
                _buildTokenUsage(message.tokenUsage),
              ],
              if (!message.isUserMessage && message.entities.isNotEmpty)
                _buildEntityCards(message.entities),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThreadCompleteMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 33,
            height: 1,
            color: const Color(0xFF009951),
          ),
          const SizedBox(width: 8),
          Text(
            'end of thread',
            style: AppTypography.body.copyWith(
              color: const Color(0xFF009951),
              fontSize: 14,
              fontFamily: 'Blacker Display',
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 33,
            height: 1,
            color: const Color(0xFF009951),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: Text(
        message.content,
        style: AppTypography.welcomeText.copyWith(
          color: message.isUserMessage ? Colors.white : const Color(0xFFE5A000),
        ),
      ),
    );
  }

  Widget _buildTokenUsage(Map<String, int>? tokenUsage) {
    return Text(
      'token usage ${tokenUsage?['prompt_tokens'] ?? 0} + ${tokenUsage?['completion_tokens'] ?? 0}',
      style: AppTypography.caption.copyWith(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget _buildEntityCards(List<Entity> entities) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: entities.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) => EntityCard(entity: entities[index]),
        ),
      ),
    );
  }
}
