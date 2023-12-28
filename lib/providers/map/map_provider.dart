import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  LatLng? pickupLocation;
  LatLng? endLocation;

  List<LatLng> polylineCordinates = [];

  Position? currentPositionOfUser;

  //final Set<Polyline> _polyline = {};
  Set<Marker> markers = Set<Marker>();

  GoogleMapController? controllerGoogleMap;

  final TextEditingController pickupLocationController =
      TextEditingController();
  final TextEditingController endLocationController = TextEditingController();

  void drowPolyline(String placeID) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
      PointLatLng(pickupLocation!.latitude, pickupLocation!.longitude),
      PointLatLng(endLocation!.latitude, endLocation!.longitude),
    );

    polylineCordinates.clear();

    polylineResult.points.forEach(
      (PointLatLng points) => polylineCordinates.add(
        LatLng(points.latitude, points.longitude),
      ),
    );
    notifyListeners();
  }

  gerCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    currentPositionOfUser = positionOfUser;

    LatLng positionOfUserInLatLng = LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserInLatLng, zoom: 45);

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    notifyListeners();
  }

  void focusCameraOnPickupAndEndLocations() {
    if (pickupLocation != null && endLocation != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          pickupLocation!.latitude < endLocation!.latitude
              ? pickupLocation!.latitude
              : endLocation!.latitude,
          pickupLocation!.longitude < endLocation!.longitude
              ? pickupLocation!.longitude
              : endLocation!.longitude,
        ),
        northeast: LatLng(
          pickupLocation!.latitude > endLocation!.latitude
              ? pickupLocation!.latitude
              : endLocation!.latitude,
          pickupLocation!.longitude > endLocation!.longitude
              ? pickupLocation!.longitude
              : endLocation!.longitude,
        ),
      );

      controllerGoogleMap!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50.0),
      );
    }
  }

  updateUI() {
    endLocationController.text = '';
    endLocation = null;
    notifyListeners();
  }
}
