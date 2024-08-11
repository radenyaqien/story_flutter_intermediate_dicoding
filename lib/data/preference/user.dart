import 'dart:convert';

class User {
  String? userId;
  String? token;
  String? name;

  User({
    this.userId,
    this.token,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'token': token, 'name': name};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      token: map['token'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.userId == userId &&
        other.token == token &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(userId, token, name);

  @override
  String toString() => 'User(userId: $userId, token: $token,name:$name)';
}
