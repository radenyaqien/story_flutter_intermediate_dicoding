// To parse this JSON data, do
//
//     final storyResponse = storyResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyflutter/data/model/story.dart';

part 'detail_story_response.freezed.dart';
part 'detail_story_response.g.dart';

@freezed
class DetailStoryResponse  with _$DetailStoryResponse {
  const factory DetailStoryResponse({
    required bool error,
    required String message,
    required Story story,
  }) = _DetailStoryResponse;

  factory DetailStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryResponseFromJson(json);
}
