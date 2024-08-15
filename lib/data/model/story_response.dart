// To parse this JSON data, do
//
//     final storyResponse = storyResponseFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyflutter/data/model/story.dart';

part 'story_response.g.dart';
part 'story_response.freezed.dart';

StoryResponse storyResponseFromJson(String str) =>
    StoryResponse.fromJson(json.decode(str));

String storyResponseToJson(StoryResponse data) => json.encode(data.toJson());

@freezed
class StoryResponse with _$StoryResponse  {


  const factory StoryResponse({
  required bool error,
  required String message,
   @JsonKey(name: "listStory")
   required List<Story> listStory})= _StoryResponse;

  factory StoryResponse.fromJson(Map<String, dynamic> json) => _$StoryResponseFromJson(json);

}
