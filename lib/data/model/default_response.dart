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
