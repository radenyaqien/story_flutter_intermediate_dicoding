import 'package:storyflutter/data/preference/preference_helper.dart';
import 'package:storyflutter/data/preference/user.dart';
import 'package:storyflutter/data/remote/auth_service.dart';

class AuthRepository {
  final PreferenceHelper preferenceHelper;
  final AuthService authService;

  AuthRepository({required this.preferenceHelper, required this.authService});

  Future<bool> isLoggedIn() async {
    return preferenceHelper.isLoggedIn();
  }

  Future<bool> login(String emaill, String passsword) async {
    try {
      var response = await authService.login(emaill, passsword);
      return preferenceHelper.saveUser(response.user);
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String emaill, String passsword) async {
    try {
      await authService.register(name, emaill, passsword);
      return true;
    } catch (e) {
      return false;
    }
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
