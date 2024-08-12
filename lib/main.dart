import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/data/preference/preference_helper.dart';
import 'package:storyflutter/data/remote/auth_service.dart';
import 'package:storyflutter/routes/router_delegate.dart';
import 'package:storyflutter/ui/addstory/provider/add_story_provider.dart';
import 'package:storyflutter/ui/auth/provider/auth_provider.dart';
import 'package:storyflutter/ui/story/provider/page_manager.dart';
import 'package:storyflutter/ui/story/provider/story_list_provider.dart';

import 'data/auth_repository.dart';
import 'data/remote/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouterDelegate myRouterDelegate;
  late AuthRepository authRepository;
  final apiService = ApiService();
  final authService = AuthService();
  final preferenceHelper = PreferenceHelper();

  @override
  void initState() {
    authRepository = AuthRepository(
        preferenceHelper: preferenceHelper, authService: authService);
    myRouterDelegate = AppRouterDelegate(authRepository);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(authRepository: authRepository),
          ),
          ChangeNotifierProvider(create: (context) => PageManager()),
          ChangeNotifierProvider<StoryListProvider>(
              create: (_) => StoryListProvider(
                  service: apiService, preferenceHelper: preferenceHelper)),
          ChangeNotifierProvider(
            create: (_) => AddStoryProvider(
                apiService: apiService, authRepository: authRepository),
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Router(
            routerDelegate: myRouterDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        ));
  }
}
