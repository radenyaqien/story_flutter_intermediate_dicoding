import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:storyflutter/data/model/detail_story_response.dart';
import 'package:storyflutter/data/model/story_response.dart';

import '../model/default_response.dart';

class ApiService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1/';

  ApiService();

  Future<StoryResponse> fetchAllStories(
      String token, int page, int size, loc) async {
    final response = await http.get(
        Uri.parse("${baseUrl}stories?page=$page&size=$size&location=$loc"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      return StoryResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.notFound) {
      return const StoryResponse(
          error: true, message: "data kosong", listStory: []);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      return const StoryResponse(
          error: true, message: "tidak memiliki akses", listStory: []);
    } else {
      throw Exception('periksa koneksi anda');
    }
  }

  Future<DetailStoryResponse> fetchStory(String token, String id) async {
    final response = await http.get(Uri.parse("${baseUrl}stories/$id"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      return DetailStoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('periksa koneksi anda');
    }
  }

  Future<DefaultResponse> addStory(
    String? token,
    String desc,
    String fileName,
    List<int> bytes,
    double? lat,
    double? lon,
  ) async {
    final uri = Uri.parse("${baseUrl}stories");
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": desc,
      "lat": lat?.toString() ?? "",
      "lon": lon?.toString() ?? ""
    };
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (kDebugMode) {
      print({"addstory": statusCode, "res": responseData});
    }
    if (statusCode == 201) {
      final DefaultResponse uploadResponse = DefaultResponse.fromJson(
        json.decode(responseData),
      );
      return uploadResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
