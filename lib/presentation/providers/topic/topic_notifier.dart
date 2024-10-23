import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/domain/usecases/topic/get_topics_usecase.dart';
import 'package:flywall/presentation/providers/topic/topic_state.dart';

class TopicNotifier extends StateNotifier<TopicState> {
  final GetTopicsUseCase _getTopicsUseCase;

  TopicNotifier(this._getTopicsUseCase) : super(const TopicState.initial());

  Future<void> getTopics({int page = 1, int pageSize = 10}) async {
    state = const TopicState.loading();
    final result =
        await _getTopicsUseCase.execute(page: page, pageSize: pageSize);
    state = result.fold(
      (failure) => TopicState.error(failure),
      (topics) => TopicState.loaded(topics),
    );
  }
}
