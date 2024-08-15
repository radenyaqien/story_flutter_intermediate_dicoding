import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/ui/addstory/provider/maps_provider.dart';

import '../story/provider/page_manager.dart';

class MapsScreen extends StatelessWidget {
  final double lat;
  final double lon;
  final Function onSave;

  const MapsScreen({
    super.key,
    required this.lat,
    required this.lon, required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapsProvider>(
      create: (context) => MapsProvider(startLat: lat, startLon: lon),
      builder: (ctx, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Ubah Lokasi"),
            actions: [
              Consumer<MapsProvider>(builder: (context, provider, child) {
                return TextButton(
                    onPressed: () {
                      if (context.mounted) {
                        context
                            .read<PageManager>()
                            .returnDataLocation(provider.currLatLon!);
                      }
                     onSave();
                    },
                    child: const Text("save"));
              })
            ],
          ),
          body: SafeArea(
            child: Center(
              child: Consumer<MapsProvider>(
                builder: (context, provider, child) {
                  return Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat, lon),
                          zoom: 15,
                        ),
                        markers: provider.markers,
                        onMapCreated: (controller) {
                          provider.mapController = controller;
                        },
                        onTap: (argument) {
                          provider.setNewMarker(
                            lat: argument.latitude,
                            lon: argument.longitude,
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextField(
                              controller: provider.addressController,
                              enabled: false,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
