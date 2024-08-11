// To parse this JSON data, do
//
//     final storyResponse = storyResponseFromJson(jsonString);

import 'dart:convert';

import 'package:storyflutter/data/model/story.dart';

DetailStoryResponse storyResponseFromJson(String str) =>
    DetailStoryResponse.fromJson(json.decode(str));

String storyResponseToJson(DetailStoryResponse data) => json.encode(data.toJson());

class DetailStoryResponse {
  bool error;
  String message;
  Story story;

  DetailStoryResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStoryResponse.fromJson(Map<String, dynamic> json) => DetailStoryResponse(
        error: json["error"],
        message: json["message"],
        story: Story.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };
}
