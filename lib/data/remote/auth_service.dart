import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:storyflutter/data/model/default_response.dart';
import 'package:storyflutter/data/remote/api_service.dart';

import '../model/login_response.dart';

class AuthService {
  Future<LoginResponse> login(String email, String passsword) async {
    final response = await http.post(Uri.parse("${ApiService.baseUrl}login"),
        body: {"email": email, "password": passsword});
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('periksa koneksi anda');
    }
  }

  Future<DefaultResponse> register(
      String name, String email, String passsword) async {
    final response = await http.post(Uri.parse("${ApiService.baseUrl}register"),
        body: {"name": name, "email": email, "password": passsword});
    if (response.statusCode == 201) {
      return DefaultResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('periksa koneksi anda');
    }
  }
}
