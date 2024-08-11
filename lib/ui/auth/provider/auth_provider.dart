import 'package:flutter/widgets.dart';
import 'package:storyflutter/data/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  AuthProvider({required this.authRepository});

  Future<bool> login(String email, String password) async {
    isLoadingLogin = true;
    notifyListeners();
    final userState = await authRepository.getUser();
    if (userState == null) {
      await authRepository.login(email, password);
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }

  Future<bool> register(String name, String email, String password) async {
    isLoadingRegister = true;
    notifyListeners();
    final userState = await authRepository.register(name, email, password);
    isLoadingRegister = false;
    notifyListeners();
    return userState;
  }
}
