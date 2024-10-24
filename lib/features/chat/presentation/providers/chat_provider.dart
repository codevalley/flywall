import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/chat_service.dart';
import '../../domain/models/message.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Service provider
final chatServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return ChatService(dio);
});

// Chat state
class ChatState {
  final List<Message> messages;
  final bool isLoading;
  final String? error;
  final String? currentThreadId;
  final Message? messageBeingRetried;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.currentThreadId,
    this.messageBeingRetried,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    String? error,
    String? currentThreadId,
    Message? messageBeingRetried,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentThreadId: currentThreadId ?? this.currentThreadId,
      messageBeingRetried: messageBeingRetried,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;

  ChatNotifier(this._chatService) : super(const ChatState());

  Future<void> sendMessage(String input) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final message = await _chatService.sendMessage(
        input,
        threadId: state.currentThreadId,
      );

      state = state.copyWith(
        messages: [...state.messages, message],
        currentThreadId: message.threadId,
        isLoading: false,
      );

      // Get thread completion status from message
      final isThreadComplete =
          message.tokenUsage?['is_thread_complete'] as bool? ?? false;
      if (isThreadComplete) {
        await Future.delayed(
            const Duration(seconds: 2)); // Give user time to read
        clearThread();
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> retryMessage(Message message) async {
    state = state.copyWith(messageBeingRetried: message);
    await sendMessage(message.content);
    state = state.copyWith(messageBeingRetried: null);
  }

  Future<void> loadThread(String threadId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final messages = await _chatService.getThread(threadId);

      state = state.copyWith(
        messages: messages,
        currentThreadId: threadId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearThread() {
    state = const ChatState();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatNotifier(chatService);
});
