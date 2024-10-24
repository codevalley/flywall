import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/domain/usecases/sidekick/send_message_usecase.dart';
import 'package:flywall/presentation/providers/chat/chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;

  ChatNotifier(this._sendMessageUseCase) : super(ChatState.initial());

  Future<void> sendMessage(String message) async {
    state = state.copyWith(isLoading: true);
    final result = await _sendMessageUseCase.execute(message, state.threadId);
    result.fold(
      (failure) => state = state.copyWith(
        error: failure.toString(),
        isLoading: false,
      ),
      (message) => state = state.copyWith(
        response: message.content,
        threadId: message.threadId,
        isLoading: false,
        error: null, // Clear any previous error
      ),
    );
  }
}
