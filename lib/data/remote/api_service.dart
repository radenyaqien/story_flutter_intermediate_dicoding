import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:storyflutter/data/model/detail_story_response.dart';
import 'package:storyflutter/data/model/story_response.dart';

import '../model/default_response.dart';

class ApiService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1/';

  ApiService();

  Future<StoryResponse> fetchAllStories(String token) async {
    final response = await http.get(Uri.parse("${baseUrl}stories"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      return StoryResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.notFound) {
      return StoryResponse(error: true, message: "data kosong", listStory: []);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      return StoryResponse(
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

  Future<DefaultResponse> addStory(String description, List<int> bytes,
      String fileName, String token) async {
    final uri = Uri.parse("${baseUrl}stories");
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
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

    if (statusCode == 201) {
      final DefaultResponse uploadResponse = DefaultResponse.fromJson(
        responseData,
      );
      return uploadResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
