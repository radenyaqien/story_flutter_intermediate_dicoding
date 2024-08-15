import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/ui/addstory/provider/add_story_provider.dart';

import '../story/provider/page_manager.dart';

class FormAddStory extends StatefulWidget {
  const FormAddStory({super.key, required this.changeAddress});

  final Function(double lat, double lon) changeAddress;

  @override
  State<FormAddStory> createState() => _FormAddStoryState();
}

class _FormAddStoryState extends State<FormAddStory> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: context.watch<AddStoryProvider>().imagePath == null
                  ? const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        size: 100,
                      ),
                    )
                  : _showImage()),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  _onCameraView();
                },
                child: const Text('Camera'),
              ),
              ElevatedButton(
                onPressed: () {
                  _onGalleryView();
                },
                child: const Text('Gallery'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            onChanged: (text) {
              Provider.of<AddStoryProvider>(context, listen: false)
                  .changeDescription(text);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          // ---- Location Field ----

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Address",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          Consumer<AddStoryProvider>(
            builder: (context, value, child) {
              return TextField(
                controller: value.addressController,
                enabled: false,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),

          Consumer<AddStoryProvider>(
            builder: (context, provider, child) {
              return Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: provider.currLatLon != null
                      ? () async {

                          widget.changeAddress(provider.currLatLon!.latitude,
                              provider.currLatLon!.longitude);
                          final data = await context
                              .read<PageManager>()
                              .waitForLocationResult();

                          if (data != null) {

                            provider.getPosition(
                              lat: data.latitude,
                              lon: data.longitude,
                            );
                          }
                        }
                      : null,
                  child: Text(
                    "Ubah Lokasi",
                    style: TextStyle(
                      color: provider.currLatLon != null
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          context.watch<AddStoryProvider>().isUploading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _onUpload();
                    }
                  },
                  child: const Text('Upload'),
                ),
        ],
      ),
    );
  }


  _onUpload() async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final uploadProvider = context.read<AddStoryProvider>();

    final imagePath = uploadProvider.imagePath;
    final imageFile = uploadProvider.imageFile;
    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await uploadProvider.compressImage(bytes);

    await uploadProvider.uploadStory(
      newBytes,
      fileName,
    );

    if (uploadProvider.uploadResponse != null) {
      uploadProvider.setImageFile(null);
      uploadProvider.setImagePath(null);
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );
    if (context.mounted) {
      context.read<PageManager>().returnData(true);
    }
  }

  _onGalleryView() async {
    final provider = context.read<AddStoryProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<AddStoryProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<AddStoryProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
