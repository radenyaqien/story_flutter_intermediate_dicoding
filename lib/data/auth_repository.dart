import 'package:flutter/foundation.dart';
import 'package:storyflutter/data/preference/preference_helper.dart';
import 'package:storyflutter/data/preference/user.dart';
import 'package:storyflutter/data/remote/auth_service.dart';

class AuthRepository {
  final PreferenceHelper preferenceHelper;
  final AuthService authService;

  AuthRepository({required this.preferenceHelper, required this.authService});

  Future<bool> isLoggedIn() async {
    return await preferenceHelper.isLoggedIn();
  }

  Future<bool> login(String emaill, String passsword) async {
    try {
      final response = await authService.login(emaill, passsword);

      User user = User(
          userId: response.loginResult.userId,
          name: response.loginResult.name,
          token: response.loginResult.token);
      await preferenceHelper.saveUser(user);
     final loginsuccess = await preferenceHelper.login();
     if (kDebugMode) {
       print("isLogin : $loginsuccess");
     }
      return loginsuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String emaill, String passsword) async {
    final response = await authService.register(name, emaill, passsword);

    return !response.error;
  }

  Future<bool> deleteUser() async {
    return preferenceHelper.deleteUser();
  }

  Future<bool> logout() async {
    return preferenceHelper.logout();
  }

  Future<User?> getUser() async {
    return preferenceHelper.getUser();
  }
}
