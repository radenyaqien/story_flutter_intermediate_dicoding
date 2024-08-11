import 'package:flutter/cupertino.dart';
import 'package:storyflutter/data/remote/api_service.dart';

import '../../data/model/story.dart';
import '../../data/preference/preference_helper.dart';
import '../../utils/data_state.dart';

class DetailStoryProvider extends ChangeNotifier {
  String _id = "";
  final ApiService apiService;
  final PreferenceHelper preferenceHelper;

  DetailStoryProvider(
      {required this.apiService, required this.preferenceHelper}) {
    _fetchDetailStory();
  }

  late DataState _state;

  DataState get state => _state;

  String _message = "";

  String get message => _message;

  late Story _story;

  Story get story => _story;

  Future<void> _fetchDetailStory() async {
    _state = DataState.loading;
    notifyListeners();
    try {
      final user = await preferenceHelper.getUser();
      final response = await apiService.fetchStory(_id, user?.token ?? "");
      if (!response.error) {
        _story = response.story;
        _state = DataState.hasData;
        notifyListeners();
      } else {
        _message = "Id Story tidak ditemukan";
        _state = DataState.noData;
        notifyListeners();
      }
    } on Exception {
      _message = "Terjadi kesalahan, Periksa koneksi anda";
      _state = DataState.error;
    }

    notifyListeners();
  }

  void setId(id) {
    _id = id;
  }
}
