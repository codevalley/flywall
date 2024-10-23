import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flywall/domain/entities/topic/topic.dart';
import 'package:flywall/core/errors/failures.dart';

part 'topic_state.freezed.dart';

@freezed
class TopicState with _$TopicState {
  const factory TopicState.initial() = _Initial;
  const factory TopicState.loading() = _Loading;
  const factory TopicState.loaded(List<Topic> topics) = _Loaded;
  const factory TopicState.error(Failure failure) = _Error;
}
