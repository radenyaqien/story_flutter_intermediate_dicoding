import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:storyflutter/data/auth_repository.dart';
import 'package:storyflutter/data/model/default_response.dart';
import 'package:storyflutter/data/remote/api_service.dart';

class AddStoryProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;
  final ApiService apiService;
  final AuthRepository authRepository;
  String _description = "";
  bool isUploading = false;
  String message = "";
  DefaultResponse? uploadResponse;
  LatLng? _currLatLon;

  LatLng? get currLatLon => _currLatLon;
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  AddStoryProvider({required this.apiService, required this.authRepository}) {
    _getCurrentPosition();
  }

  TextEditingController get descController => _descController;

  TextEditingController get addressController => _addressController;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  Future<void> uploadStory(newBytes, String fileName) async {
    try {
      message = "";
      uploadResponse = null;
      isUploading = true;
      notifyListeners();
      final user = await authRepository.getUser();
      uploadResponse = await apiService.addStory(
          user?.token ?? "",
          _description,
          fileName,
          newBytes,
          _currLatLon?.latitude ?? 0.0,
          _currLatLon?.longitude ?? 0.0);
      message = uploadResponse?.message ?? "success";
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  void changeDescription(String desc) {
    _description = desc;
    notifyListeners();
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(bytes)!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      ///
      compressQuality -= 10;

      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }

  Future<void> _getCurrentPosition() async {
    _addressController.text = "Loading...";

    final Location location = Location();
    late LocationData locationData;

    final state = await _getPermission(location);

    if (!state) return;

    locationData = await location.getLocation();
    final latLng = LatLng(
      locationData.latitude!,
      locationData.longitude!,
    );

    final info = await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    if (info.isNotEmpty) {
      final place = info[0];
      _addressController.text =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } else {
      _addressController.text = "Location not found ";
    }

    _currLatLon = latLng;
    notifyListeners();
  }

  Future<void> getPosition({required double lat, required double lon}) async {
    _addressController.text = "Loading...";

    final Location location = Location();
    final state = await _getPermission(location);

    if (!state) return;

    final info = await geo.placemarkFromCoordinates(
      lat,
      lon,
    );

    if (info.isNotEmpty) {
      final place = info[0];
      _addressController.text =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } else {
      _addressController.text = "Location not found ";
    }

    _currLatLon = LatLng(lat, lon);
    notifyListeners();
  }

  Future<bool> _getPermission(Location location) async {
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _addressController.text = "Please enable location service";
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _addressController.text = "Location permission needed";
        return false;
      }
    }

    return true;
  }
}
