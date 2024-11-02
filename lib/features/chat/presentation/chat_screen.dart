import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../widgets/search_input.dart';
import '../widgets/message_list.dart';
import '../widgets/entity/entity_detail_view.dart';
import 'providers/chat_provider.dart';
import 'providers/entity_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_logo.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final scrollController = ScrollController();
  String? _userName;
  String? _userSecret;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = ref.read(sessionStorageProvider);
    final userName = await storage.getUserName();
    final userSecret = await storage.getUserSecret();
    if (mounted) {
      setState(() {
        _userName = userName;
        _userSecret = userSecret;
      });
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

  void _copySecretToClipboard() async {
    if (_userSecret != null) {
      await Clipboard.setData(ClipboardData(text: _userSecret!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Secret copied to clipboard'),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.green,
          ),
        );
      }
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
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    // Listen to keyboard visibility
    _isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 48),
                // Logo Section with tap handler
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: hasMessages
                      ? MiniAppLogo(onTap: _copySecretToClipboard)
                      : AppLogo(
                          isExpanded: !_isKeyboardVisible,
                        ),
                ),

                if (!hasMessages) ...[
                  const Spacer(),
                  // Welcome Message with new style
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 62),
                    child: Text(
                      'I can help with your existing information\n\nor help create new topics, tasks or notes.',
                      textAlign: TextAlign.center,
                      style: AppTypography.welcomeText.copyWith(
                        color: AppColors.yellow,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ] else
                  Expanded(
                    child: MessageList(
                      messages: chatState.messages,
                      scrollController: scrollController,
                      isThreadComplete: isThreadComplete,
                    ),
                  ),

                // Input Section
                SearchInput(
                  onSubmitted: (input) {
                    if (input.trim().isNotEmpty) {
                      if (isThreadComplete) {
                        ref.read(chatProvider.notifier).clearThread();
                      }
                      ref.read(chatProvider.notifier).sendMessage(input);
                    }
                  },
                  enabled: !chatState.isLoading,
                  isThreadActive: hasMessages,
                ),
              ],
            ),

            // Entity Detail View
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
