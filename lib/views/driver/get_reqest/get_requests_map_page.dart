import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxia/global/global.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/custom_info_window.dart';

class GetRequestsMap extends StatefulWidget {
  const GetRequestsMap({super.key});

  @override
  State<GetRequestsMap> createState() => _GetRequestsMapState();
}

class _GetRequestsMapState extends State<GetRequestsMap> {
  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  Position? driverLocation;

  bool isLoading = true;

  double distance = 0.00;

  Set<Marker> markers = Set<Marker>();

  GoogleMapController? controllerGoogleMap;

  @override
  void initState() {
    super.initState();
    gerCurrentLiveLocationOfUser();
  }

  void _startListening() {
    databaseReference.onValue.listen((event) {
      // Handle the added data here
      getPickupData();

      print('New data added with key');

      // You can perform additional actions here
    });
  }

  gerCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    setState(() {
      driverLocation = positionOfUser;

      LatLng positionOfUserInLatLng =
          LatLng(driverLocation!.latitude, driverLocation!.longitude);

      CameraPosition cameraPosition =
          CameraPosition(target: positionOfUserInLatLng, zoom: 12);

      controllerGoogleMap!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      isLoading = false;
    });
  }

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('rides');

  //Get user pickup request distance
  void getPickupData() {
    markers.clear();
    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map?;

      if (values != null) {
        values.forEach((key, rideData) {
          print('Key: $key');

          if (rideData is Map &&
              rideData.containsKey('picupLocationLat') &&
              rideData.containsKey('picupLocationLong')) {
            print('picupLocationLat: ${rideData['picupLocationLat']}');
            print('picupLocationLong: ${rideData['picupLocationLong']}');

            getDistance(driverLocation!.latitude, driverLocation!.longitude,
                rideData['picupLocationLat'], rideData['picupLocationLong']);
          } else {
            print('Invalid data structure or missing values for key $key');
          }
        });
      } else {
        print('No data found under "rides" node.');
      }
    });
  }

  Future<void> getDistance(double? startLatitude, double? startLongitude,
      double? endLatitude, double? endLongitude) async {
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

        setState(() {
          distance = double.parse(distanceText.split(' ')[0].toString());
        });
        print(distance);

        if (distance < 10.0) {
          await markers.add(
            Marker(
              icon: BitmapDescriptor.defaultMarker,
              markerId: MarkerId('$endLatitude'),
              position: LatLng(endLatitude!, endLongitude!),
              infoWindow: customInfoWindow(context, distance),
            ),
          );
        } else {
          print("no");
        }

        return jsonDecode(response.body);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: false,
            markers: markers,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController mapController) {
              if (!googleMapCompleterController.isCompleted) {
                googleMapCompleterController.complete(mapController);
                controllerGoogleMap = mapController;
              }
            },
            initialCameraPosition: googlePlexInitialPosition,
          ),
          isLoading
              ? Positioned(
                  top: screenHeight / 3,
                  left: 30,
                  right: 30,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Loading your location...."),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          Positioned(
            left: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                _startListening();
              },
              child: CustomButton(
                text: "Online",
                height: 50,
                width: 150,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
