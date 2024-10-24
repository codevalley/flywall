import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(false) bool isLoading,
    @Default('') String response,
    String? error,
    String? threadId,
  }) = _ChatState;

  factory ChatState.initial() => const ChatState();
}
