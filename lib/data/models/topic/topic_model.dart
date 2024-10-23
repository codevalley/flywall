import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flywall/domain/entities/topic/topic.dart';

part 'topic_model.freezed.dart';
part 'topic_model.g.dart';

@freezed
class TopicModel with _$TopicModel {
  const TopicModel._(); // Add this line

  const factory TopicModel({
    required String id,
    required String name,
    required String description,
    required List<String> keywords,
    required List<String> relatedPeople,
    required List<String> relatedTasks,
  }) = _TopicModel;

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);

  factory TopicModel.fromDomain(Topic topic) => TopicModel(
        id: topic.id,
        name: topic.name,
        description: topic.description,
        keywords: topic.keywords,
        relatedPeople: topic.relatedPeople,
        relatedTasks: topic.relatedTasks,
      );

  Topic toDomain() => Topic(
        id: id,
        name: name,
        description: description,
        keywords: keywords,
        relatedPeople: relatedPeople,
        relatedTasks: relatedTasks,
      );
}
