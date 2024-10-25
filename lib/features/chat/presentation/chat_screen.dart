// Update lib/features/chat/presentation/chat_screen.dart to include entity state handling

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/search_input.dart';
import '../widgets/message_list.dart';
import '../widgets/entity/entity_detail_view.dart';
import 'providers/chat_provider.dart';
import 'providers/entity_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final scrollController = ScrollController();

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    // Add entity state watch if needed
    final selectedEntity = ref.watch(selectedEntityProvider);

    // Listen for changes and scroll to bottom when new messages arrive
    ref.listen<ChatState>(chatProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SearchInput(
                    onSubmitted: (input) {
                      if (input.trim().isNotEmpty) {
                        ref.read(chatProvider.notifier).sendMessage(input);
                      }
                    },
                    enabled: !chatState.isLoading,
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      MessageList(
                        messages: chatState.messages,
                        scrollController: scrollController,
                      ),
                      if (chatState.isLoading)
                        const Positioned(
                          top: 16,
                          right: 16,
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // Add entity detail handling if needed
            if (selectedEntity != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () =>
                      ref.read(selectedEntityProvider.notifier).state = null,
                  child: Container(
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: EntityDetailView(
                      entity: selectedEntity,
                      onClose: () => ref
                          .read(selectedEntityProvider.notifier)
                          .state = null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
