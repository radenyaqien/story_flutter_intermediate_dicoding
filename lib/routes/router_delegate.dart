import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyflutter/ui/addstory/add_story_screen.dart';
import 'package:storyflutter/ui/addstory/maps_screen.dart';
import 'package:storyflutter/ui/auth/login/login_screen.dart';
import 'package:storyflutter/ui/detail/detail_screen.dart';
import 'package:storyflutter/ui/story/story_screen.dart';

import '../data/auth_repository.dart';
import '../ui/auth/register/register_screen.dart';
import '../ui/splash_screen.dart';

class AppRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  AppRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  List<Page> historyStack = [];
  bool? isLoggedIn;

  bool isRegister = false;
  String? selectedStory;
  bool isAddStory = false;
  bool isUpdateLocation = false;
  LatLng? _latLng;

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  List<Page> get _splashStack =>
      [
        const MaterialPage(
          key: ValueKey("SplashScreen"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack =>
      [
        MaterialPage(
          key: const ValueKey("LoginScreen"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterScreen"),
            child: RegisterScreen(
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack =>
      [
        MaterialPage(
          key: const ValueKey("StoriesListPage"),
          child: StoryScreen(
            onTapped: (id) {
              selectedStory = id;
              notifyListeners();
            },
            toFormScreen: () {
              isAddStory = true;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
          ),
        ),
        if (isAddStory)
          MaterialPage(
              key: const ValueKey("AddStoryScreen"),
              child: AddStoryScreen(
                navigateBack: () {
                  isAddStory = false;
                  notifyListeners();
                },
                changeAddress: (double lat, double lon) {
                  _latLng = LatLng(lat, lon);
                  isUpdateLocation = true;
                  notifyListeners();
                },
              )),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey(selectedStory),
            child: DetailScreen(
              id: selectedStory!,
              navigateBack: () {
                selectedStory = null;
                notifyListeners();
              },
            ),
          ),
        if (isUpdateLocation && _latLng != null)
          MaterialPage(
            key: ValueKey(_latLng),
            child: MapsScreen(
              lat: _latLng!.latitude, lon: _latLng!.longitude, onSave: () {
              _latLng = null;
              isUpdateLocation = false;
              notifyListeners();
            },),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isRegister = false;
        selectedStory = null;
        notifyListeners();
        isAddStory = false;
        isUpdateLocation = false;
        _latLng = null;
        return true;
      },
    );
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
