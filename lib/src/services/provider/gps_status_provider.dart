// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GpsStatusProvider with ChangeNotifier {
  bool _isGpsActive = false;
  Color _iconColor = Colors.red;
  late StreamController<bool> _gpsActiveController;

  Stream<bool> get isGpsActiveStream => _gpsActiveController.stream;

  GpsStatusProvider() {
    _gpsActiveController = StreamController<bool>.broadcast();
  }

  bool get isGpsActive => _isGpsActive;

  Color get iconColor => _iconColor;

  void setGpsActive(bool isActive) {
    void setGpsActive(bool isActive) {
      _isGpsActive = isActive;
      _iconColor = isActive ? Colors.green : Colors.red;
      _gpsActiveController.add(isActive);
      notifyListeners();
      if (kDebugMode) {
        print("GPS status changed: $isActive, Icon color: $_iconColor");
      }
    }
  }

  @override
  void dispose() {
    _gpsActiveController.close();
    super.dispose();
  }
}
