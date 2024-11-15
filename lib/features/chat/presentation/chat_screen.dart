import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flywall/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/search_input.dart';
import '../widgets/message_list.dart';
import '../widgets/suggestion_bubbles.dart';
import 'providers/chat_provider.dart';
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
  String? _userSecret;
  bool _isKeyboardVisible = false;
  bool _isContentScrollable = false;

  // Add suggested questions
  final List<String> _suggestions = [
    'What is my current task?',
    'Create a new note',
    'Show my recent topics',
    'Help me brainstorm',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    scrollController.addListener(_updateScrollState);
  }

  Future<void> _loadUserData() async {
    final storage = ref.read(sessionStorageProvider);
    final userSecret = await storage.getUserSecret();
    if (mounted) {
      setState(() {
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

  Future<void> _handleLogout() async {
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

    final sessionManager = ref.read(sessionManagerProvider);
    await sessionManager.clear();

    if (mounted) {
      context.go('/');
    }
  }

  void _handleLogoTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.black,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy, color: AppColors.yellow),
              title: const Text(
                'Copy Secret',
                style: TextStyle(color: AppColors.yellow),
              ),
              onTap: () {
                _copySecretToClipboard();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.logout_rounded, color: AppColors.yellow),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.yellow),
              ),
              onTap: () {
                Navigator.pop(context);
                _handleLogout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateScrollState() {
    final isScrollable = scrollController.hasClients &&
        scrollController.position.maxScrollExtent > 0;
    if (isScrollable != _isContentScrollable) {
      setState(() {
        _isContentScrollable = isScrollable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
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
        child: Column(
          children: [
            // Top section with logo
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 48, 32, 16),
              child: hasMessages
                  ? MiniAppLogo(onTap: _handleLogoTap)
                  : AppLogo(
                      isExpanded: !_isKeyboardVisible,
                    ),
            ),

            // Add separator when messages exist and content is scrollable
            if (hasMessages && _isContentScrollable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 1,
                  color: AppColors.white,
                ),
              ),

            // Main content area
            Expanded(
              child: hasMessages
                  ? MessageList(
                      messages: chatState.messages,
                      scrollController: scrollController,
                      isThreadComplete: isThreadComplete,
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'I can help with your existing information\n\nor help create new topics, tasks or notes.',
                          textAlign: TextAlign.center,
                          style: AppTypography.welcomeText.copyWith(
                            color: AppColors.yellow,
                          ),
                        ),
                      ),
                    ),
            ),

            // Bottom section with suggestions and input
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add suggestion bubbles above the input when there are no messages
                if (!hasMessages && !chatState.isLoading && !_isKeyboardVisible)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SuggestionBubbles(
                      suggestions: _suggestions,
                      onSuggestionTap: (suggestion) {
                        if (isThreadComplete) {
                          ref.read(chatProvider.notifier).clearThread();
                        }
                        ref.read(chatProvider.notifier).sendMessage(suggestion);
                      },
                      visible: !_isKeyboardVisible && !chatState.isLoading,
                    ),
                  ),

                // Input section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SearchInput(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_updateScrollState);
    scrollController.dispose();
    super.dispose();
  }
}
