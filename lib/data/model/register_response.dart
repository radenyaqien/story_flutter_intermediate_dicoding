import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_response.g.dart';
part 'register_response.freezed.dart';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));



@freezed
class RegisterResponse with _$RegisterResponse {
 const factory RegisterResponse({
    required bool error,
    required String message,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
