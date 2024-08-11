import 'package:flutter/material.dart';
import 'package:storyflutter/ui/story/story_screen.dart';

class AppRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  AppRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
        pages: [
          // MaterialPage(
          //   key: const ValueKey("QuotesListScreen"),
          //   child: StoryScreen(
          //       quotes: quotes,
          //       onTapped: (String quoteId) {
          //         setState(() {
          //           selectedQuote = quoteId;
          //         });
          //       }),
          // ),
          // if (selectedQuote != null)
          //   MaterialPage(
          //     key: ValueKey("QuoteDetailsScreen-$selectedQuote"),
          //     child: QuoteDetailsScreen(
          //       quoteId: selectedQuote!,
          //     ),
          //   ),
        ],
        onPopPage: (route, result) {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }
          //selectedQuote = null;
          notifyListeners();
          return true;
        },);
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
