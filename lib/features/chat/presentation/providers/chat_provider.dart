// lib/features/chat/presentation/providers/chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/chat_service.dart';
import '../../domain/models/message.dart';
import '../../../../core/providers/core_providers.dart';
import '../../domain/models/entity.dart';
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
  final DateTime timestamp;
  final String? threadId;
  final bool isError;
  final List<Entity> entities; // Added field for entities

  ChatMessage({
    required this.content,
    required this.isUserMessage,
    this.isThreadComplete = false,
    DateTime? timestamp,
    this.threadId,
    this.isError = false,
    this.entities = const [], // Default to empty list
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatState {
  final List<ChatMessage> messages;
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
    List<ChatMessage>? messages,
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
      messageBeingRetried: messageBeingRetried ?? this.messageBeingRetried,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;

  ChatNotifier(this._chatService) : super(const ChatState());

  Future<void> sendMessage(String message) async {
    // Add user message immediately
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(content: message, isUserMessage: true),
      ],
      isLoading: true,
      error: null,
    );

    try {
      final response = await _chatService.sendMessage(
        message,
        threadId: state.currentThreadId,
      );

      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
            content: response.content,
            isUserMessage: false,
            threadId: response.threadId,
            isThreadComplete: response.isThreadComplete,
            entities: response.entities, // Include entities from response
          ),
        ],
        currentThreadId: response.threadId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        messages: [
          ...state.messages,
          ChatMessage(
            content: 'Error: ${e.toString()}',
            isUserMessage: false,
            isError: true,
          ),
        ],
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

      // Convert Message objects to ChatMessage objects
      final chatMessages = messages
          .map((msg) => ChatMessage(
                content: msg.content,
                isUserMessage: msg.type == MessageType.text,
                threadId: msg.threadId,
                timestamp: msg.timestamp,
                isThreadComplete: msg.isThreadComplete,
              ))
          .toList();

      state = state.copyWith(
        messages: chatMessages,
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
