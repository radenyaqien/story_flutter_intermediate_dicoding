import 'package:flutter/foundation.dart';
import 'package:storyflutter/data/remote/api_service.dart';

import '../../data/model/story.dart';
import '../../data/preference/preference_helper.dart';
import '../../utils/data_state.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferenceHelper preferenceHelper;
  final String id;

  DetailStoryProvider(
      {required this.apiService,
      required this.preferenceHelper,
      required this.id}) {
    _fetchDetailStory(id);
  }

  late DataState _state;

  DataState get state => _state;

  String _message = "";

  String get message => _message;

  late Story _story;

  Story get story => _story;

  Future<void> _fetchDetailStory(String id) async {
    if (kDebugMode) {
      print("idku $id");
    }
    _state = DataState.loading;
    notifyListeners();
    try {
      final user = await preferenceHelper.getUser();
      final response = await apiService.fetchStory(
        user?.token ?? "",
        id,
      );
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
}
