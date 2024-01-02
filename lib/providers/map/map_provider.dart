import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/models/rates.dart';
import 'package:taxia/views/splash_screen/splash_screen.dart';

class MapProvider extends ChangeNotifier {
  bool isLoading = false;

  double distance = 0.0;

  double bikeCharge = 0.0;
  double carCharge = 0.0;
  double tukCharge = 0.0;

  String? id = '';

  getUserID() async {
    final prefs = await SharedPreferences.getInstance();

    id = prefs.getString('userID');
    notifyListeners();
  }

  void getVehicleRates(BuildContext context) async {
    VehicleRates? vehicleRates;

    try {
      final DocumentSnapshot ratesDoc = await FirebaseFirestore.instance
          .collection("Admin")
          .doc('prices')
          .get();

      vehicleRates = VehicleRates(
        perBike: double.parse(ratesDoc.get('perBike').toString()),
        perCar: double.parse(ratesDoc.get('perCar').toString()),
        perTuk: double.parse(ratesDoc.get('perTuk').toString()),
      );

      bikeCharge = vehicleRates.perBike;
      carCharge = vehicleRates.perCar;
      tukCharge = vehicleRates.perTuk;

      await getUserID();

      notifyListeners();
    } catch (error) {
      print(error);
    } finally {
      isLoading = false;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => SplashScreen(id: id!)));
      notifyListeners();
    }
  }

  Future<void> getDistance(
      {double? startLatitude,
      double? startLongitude,
      double? endLatitude,
      double? endLongitude}) async {
    String Url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${startLatitude},${startLongitude}&origins=${endLatitude},${endLongitude}&key=AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY';

    try {
      var response = await http.get(
        Uri.parse(Url),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        String distanceText =
            data['rows'][0]['elements'][0]['distance']['text'];

        distance = double.parse(distanceText.split(' ')[0].toString());
        //calculateCharges();
        notifyListeners();

        return jsonDecode(response.body);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
  // Completer<GoogleMapController> googleMapCompleterController =
  //     Completer<GoogleMapController>();

  // LatLng? pickupLocation;
  // LatLng? endLocation;

  // List<LatLng> polylineCordinates = [];

  // //Position? currentPositionOfUser;

  // Set<Marker> markers = Set<Marker>();

  // GoogleMapController? controllerGoogleMap;

  // final TextEditingController pickupLocationController =
  //     TextEditingController();
  // final TextEditingController endLocationController = TextEditingController();

  // void drowPolyline(String placeID) async {
  //   PolylinePoints polylinePoints = PolylinePoints();

  //   PolylineResult polylineResult =
  //       await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
  //     PointLatLng(pickupLocation!.latitude, pickupLocation!.longitude),
  //     PointLatLng(endLocation!.latitude, endLocation!.longitude),
  //   );

  //   polylineCordinates.clear();

  //   polylineResult.points.forEach(
  //     (PointLatLng points) => polylineCordinates.add(
  //       LatLng(points.latitude, points.longitude),
  //     ),
  //   );
  //   notifyListeners();
  // }

  // gerCurrentLiveLocationOfUser() async {
  //   Position positionOfUser = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);

  //   currentPositionOfUser = positionOfUser;

  //   LatLng positionOfUserInLatLng = LatLng(
  //       currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

  //   CameraPosition cameraPosition =
  //       CameraPosition(target: positionOfUserInLatLng, zoom: 45);

  //   controllerGoogleMap!
  //       .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //   notifyListeners();
  // }

  // void focusCameraOnPickupAndEndLocations() {
  //   if (pickupLocation != null && endLocation != null) {
  //     LatLngBounds bounds = LatLngBounds(
  //       southwest: LatLng(
  //         pickupLocation!.latitude < endLocation!.latitude
  //             ? pickupLocation!.latitude
  //             : endLocation!.latitude,
  //         pickupLocation!.longitude < endLocation!.longitude
  //             ? pickupLocation!.longitude
  //             : endLocation!.longitude,
  //       ),
  //       northeast: LatLng(
  //         pickupLocation!.latitude > endLocation!.latitude
  //             ? pickupLocation!.latitude
  //             : endLocation!.latitude,
  //         pickupLocation!.longitude > endLocation!.longitude
  //             ? pickupLocation!.longitude
  //             : endLocation!.longitude,
  //       ),
  //     );

  //     controllerGoogleMap!.animateCamera(
  //       CameraUpdate.newLatLngBounds(bounds, 50.0),
  //     );
  //   }
  // }
}
