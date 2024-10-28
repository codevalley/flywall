import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/search_input.dart';
import '../widgets/message_list.dart';
import '../widgets/entity/entity_detail_view.dart';
import 'providers/chat_provider.dart';
import 'providers/entity_provider.dart';
import '../../../core/providers/core_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final scrollController = ScrollController();
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final storage = ref.read(sessionStorageProvider);
    final userName = await storage.getUserName();
    if (mounted) {
      setState(() => _userName = userName);
    }
  }

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
    final selectedEntity = ref.watch(selectedEntityProvider);
    final hasMessages = chatState.messages.isNotEmpty;
    final isThreadComplete =
        chatState.messages.lastOrNull?.isThreadComplete ?? false;

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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (hasMessages)
                  Expanded(
                    child: MessageList(
                      messages: chatState.messages,
                      scrollController: scrollController,
                      isThreadComplete: isThreadComplete,
                    ),
                  ),
                SearchInput(
                  onSubmitted: (input) {
                    if (input.trim().isNotEmpty) {
                      // Clear previous thread if completed
                      if (isThreadComplete) {
                        ref.read(chatProvider.notifier).clearThread();
                      }
                      ref.read(chatProvider.notifier).sendMessage(input);
                    }
                  },
                  enabled: !chatState.isLoading,
                  isThreadActive: hasMessages,
                  userName: _userName,
                ),
              ],
            ),
            if (chatState.isLoading)
              Positioned(
                bottom: 90, // Position loader just above the search box
                right: 32,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const CircularProgressIndicator(),
                ),
              ),
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
}
