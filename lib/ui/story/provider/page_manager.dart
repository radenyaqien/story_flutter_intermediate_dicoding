import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageManager extends ChangeNotifier {
  late Completer<bool> _completer;
  late Completer<LatLng?> _latlong;

  Future<bool> waitForResult() async {
    _completer = Completer<bool>();
    return _completer.future;
  }

  void returnData(bool value) {
    _completer.complete(value);
  }

  Future<LatLng?> waitForLocationResult() async {
    _latlong = Completer<LatLng?>();
    return _latlong.future;
  }

  void returnDataLocation(LatLng value) {
    _latlong.complete(value);
  }
}
