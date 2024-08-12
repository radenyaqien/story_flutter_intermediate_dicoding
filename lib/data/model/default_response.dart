import 'dart:convert';

class DefaultResponse {
  final bool error;
  final String message;

  DefaultResponse({
    required this.error,
    required this.message,
  });

  factory DefaultResponse.fromMap(Map<String, dynamic> map) {
    return DefaultResponse(
      error: map['error'] ?? false,
      message: map['message'] ?? '',
    );
  }

  factory DefaultResponse.fromJson(String source) =>
      DefaultResponse.fromMap(json.decode(source));
}



RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
  bool error;
  String message;

  RegisterResponse({
    required this.error,
    required this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}

