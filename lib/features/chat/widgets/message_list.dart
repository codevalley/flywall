import 'package:flutter/material.dart';
import '../presentation/providers/chat_provider.dart';
import 'entity/entity_card_factory.dart';
import '../domain/models/entity_base.dart';
import '../../../core/theme/theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimatedScrollView extends StatefulWidget {
  final Widget child;
  final bool shouldAnimate;

  const AnimatedScrollView({
    super.key,
    required this.child,
    this.shouldAnimate = true,
  });

  @override
  State<AnimatedScrollView> createState() => _AnimatedScrollViewState();
}

class _AnimatedScrollViewState extends State<AnimatedScrollView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, 0),
          end: const Offset(-0.05, 0),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(-0.05, 0),
          end: const Offset(0, 0),
        ),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.shouldAnimate) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _controller.forward().then((_) => _controller.reset());
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

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

    // Scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
      child: message.isUserMessage
          ? Text(
              message.content,
              style: AppTypography.body.copyWith(
                color: Colors.white,
              ),
            )
          : MarkdownBody(
              data: message.content,
              styleSheet: MarkdownStyleSheet(
                p: AppTypography.body.copyWith(
                  color: const Color(0xFFE5A000),
                ),
                strong: AppTypography.body.copyWith(
                  color: const Color(0xFFE5A000),
                  fontWeight: FontWeight.bold,
                ),
                em: AppTypography.body.copyWith(
                  color: const Color(0xFFE5A000),
                  fontStyle: FontStyle.italic,
                ),
                code: AppTypography.body.copyWith(
                  color: const Color(0xFFE5A000),
                  fontFamily: 'monospace',
                  backgroundColor: Colors.black26,
                ),
                codeblockDecoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
                blockquote: AppTypography.body.copyWith(
                  color: const Color(0xFFE5A000).withOpacity(0.8),
                ),
                listBullet: AppTypography.body.copyWith(
                  color: const Color(0xFFE5A000),
                ),
                // Add more styles as needed
              ),
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(Uri.parse(href));
                }
              },
              selectable: true, // Makes text selectable
            ),
    );
  }

  Widget _buildTokenUsage(Map<String, dynamic>? tokenUsage) {
    if (tokenUsage == null) return const SizedBox.shrink();

    return Text(
      'token usage ${tokenUsage['prompt_tokens'] ?? 0} + ${tokenUsage['completion_tokens'] ?? 0}',
      style: AppTypography.footnote.copyWith(
        color: const Color(0xFFE5A000),
        fontSize: 12,
      ),
    );
  }

  Widget _buildEntityCards(List<EntityBase> entities) {
    if (entities.isEmpty) return const SizedBox.shrink();

    final showPeek = entities.length > 1;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate card width to ensure peek
          final availableWidth = constraints.maxWidth;
          final cardWidth =
              availableWidth - 48.0; // Account for horizontal padding
          final effectiveCardWidth =
              showPeek ? cardWidth - 40 : cardWidth; // Show peek of next card

          return AnimatedScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                left: 24,
                right: showPeek ? 0 : 24,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entities.asMap().entries.map((entry) {
                  final index = entry.key;
                  final entity = entry.value;
                  final isLast = index == entities.length - 1;
                  final rightPadding = isLast ? 24.0 : 12.0;

                  return Padding(
                    padding: EdgeInsets.only(right: rightPadding),
                    child: SizedBox(
                      width: effectiveCardWidth,
                      child: EntityCardFactory.createCard(
                        entity,
                        onTap: () {
                          // Your existing onTap logic here if any
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
