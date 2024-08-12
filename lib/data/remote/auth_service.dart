import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:storyflutter/data/model/default_response.dart';
import 'package:storyflutter/data/remote/api_service.dart';

import '../model/login_response.dart';

class AuthService {
  Future<LoginResponse> login(String email, String passsword) async {
    final response = await http.post(Uri.parse("${ApiService.baseUrl}login"),
        body: {"email": email, "password": passsword});
    if (kDebugMode) {
      print("login${response.body}");
    }
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('periksa koneksi anda');
    }
  }

  Future<RegisterResponse> register(
      String name, String email, String passsword) async {
    final response = await http.post(Uri.parse("${ApiService.baseUrl}register"),
        body: {"name": name, "email": email, "password": passsword});

    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      return RegisterResponse(error : true,message: "password or email is invalid");
    }
  }
}
