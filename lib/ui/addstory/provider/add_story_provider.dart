import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
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

  AddStoryProvider({required this.apiService, required this.authRepository});

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
          _description, newBytes, fileName, user?.token ?? "");
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
}
