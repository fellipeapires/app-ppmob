import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionProvider with ChangeNotifier {
  Future<PermissionStatus> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status;
  }
}
