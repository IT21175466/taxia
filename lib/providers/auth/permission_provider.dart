import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionProvider extends ChangeNotifier {
  bool isLocationPermissionGranted = false;
  bool isStoragePermissionGranted = false;
  bool isAllPermissionGranted = false;

  requestLocationPermissions(BuildContext context) async {
    PermissionStatus status = await Permission.location.request();

    if (status == PermissionStatus.granted) {
      isLocationPermissionGranted = true;
      debugPrint("Permission Granted");
    }

    if (status == PermissionStatus.denied) {
      debugPrint("Permission Denied");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Location Access Required!'),
          action: SnackBarAction(
              label: 'Open App Settings',
              onPressed: () {
                openAppSettings();
              }),
        ),
      );
    }

    notifyListeners();
  }

  requestStoragePermissions(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      isStoragePermissionGranted = true;
      debugPrint("Permission Granted");
    }

    if (status == PermissionStatus.denied) {
      debugPrint("Permission Denied");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Storage Access Required!'),
          action: SnackBarAction(
              label: 'Open App Settings',
              onPressed: () {
                openAppSettings();
              }),
        ),
      );
    }

    notifyListeners();
  }

  requestCamaraPermissions(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
      debugPrint("Permission Granted");
    }

    notifyListeners();
  }

  requestMicPermissions(BuildContext context) async {
    PermissionStatus status = await Permission.microphone.request();

    if (status == PermissionStatus.granted) {
      debugPrint("Permission Granted");
    }

    notifyListeners();
  }

  checkAllPermissions() {
    if (isLocationPermissionGranted == true) {
      isAllPermissionGranted = true;
      notifyListeners();
    } else {
      debugPrint("Permission Error");
    }
  }

  savePermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showPermission', true);
    notifyListeners();
  }
}
