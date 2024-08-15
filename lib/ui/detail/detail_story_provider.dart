import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyflutter/data/remote/api_service.dart';
import 'package:geocoding/geocoding.dart' as geo;
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
    _getCurrAddress();
    notifyListeners();
  }

  final Set<Marker> markers = {};
  String _currAddress = "Location Unknown";
  void _createMarker() {
    if (story.lat != null && story.lon != null) {
      final marker = Marker(
        markerId: const MarkerId("curr_position"),
        infoWindow: InfoWindow(title: _currAddress),
        position: LatLng(story.lat!, story.lon!),
      );

      markers.add(marker);
      notifyListeners();
    }
  }

  Future<void> _getCurrAddress() async {
    if (story.lat != null && story.lon != null) {
      final info = await geo.placemarkFromCoordinates(
        story.lat!,
        story.lon!,
      );

      if (info.isNotEmpty) {
        final place = info[0];
        _currAddress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      }

      _createMarker();
    }
  }
}
