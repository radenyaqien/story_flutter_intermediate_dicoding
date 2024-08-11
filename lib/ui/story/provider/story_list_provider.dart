import 'package:flutter/cupertino.dart';
import 'package:storyflutter/data/model/story.dart';
import 'package:storyflutter/data/remote/api_service.dart';
import 'package:storyflutter/utils/data_state.dart';

import '../../../data/preference/preference_helper.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiService service;
  final PreferenceHelper preferenceHelper;

  StoryListProvider({required this.service, required this.preferenceHelper}) {
    fetchAllStory();
  }

  late DataState _state;

  DataState get state => _state;

  String _message = "";

  String get message => _message;

  late List<Story> _result;

  List<Story> get result => _result;

  Future<void> fetchAllStory() async {
    _state = DataState.loading;
    notifyListeners();
    try {
      final user = await preferenceHelper.getUser();
      var response = await service.fetchAllStories(user?.token ?? "");
      if (!response.error) {
        _state = DataState.hasData;
        _result = response.listStory;
        notifyListeners();
      } else {
        _state = DataState.noData;
        _message = response.message;
        notifyListeners();
      }
    } on Exception {
      _state = DataState.error;
      notifyListeners();
      _message = "No Internet Connection";
    }
  }
}
