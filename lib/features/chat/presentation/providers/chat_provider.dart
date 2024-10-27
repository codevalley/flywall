// lib/features/chat/presentation/providers/chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/chat_service.dart';
import '../../domain/models/message.dart';
import '../../../../core/providers/core_providers.dart';
import '../../domain/presentation/providers/chat_providers.dart';
// Export ChatState for use in other files
export '../../domain/models/message.dart';

// Service provider
final chatServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatService(apiClient);
});

class ChatMessage {
  final String content;
  final bool isUserMessage;
  final bool isThreadComplete;

  ChatMessage({
    required this.content,
    required this.isUserMessage,
    this.isThreadComplete = false,
  });
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;

  ChatNotifier(this._chatService) : super(const ChatState());

  void sendMessage(String message) {
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(content: message, isUserMessage: true),
      ],
      isLoading: true,
    );

    // Existing API call logic...
    // When adding the API response, use:
    // ChatMessage(content: apiResponse, isUserMessage: false)
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

// Export the provider for use in other files
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatNotifier(chatService);
});
