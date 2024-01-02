import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxia/global/global.dart';
import 'package:taxia/widgets/custom_button.dart';

class GetRequestsMap extends StatefulWidget {
  const GetRequestsMap({super.key});

  @override
  State<GetRequestsMap> createState() => _GetRequestsMapState();
}

class _GetRequestsMapState extends State<GetRequestsMap> {
  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  Position? driverLocation;

  bool isLoading = false;

  double distance = 0.00;

  Set<Marker> markers = Set<Marker>();

  GoogleMapController? controllerGoogleMap;

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

  //Get user pickup request distance
  void getPickupData() {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref('rides');

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

        //if(distance < 5.0){

        await markers.add(
          Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId('$endLatitude'),
            position: LatLng(endLatitude!, endLongitude!),
            infoWindow: InfoWindow(title: ' Location'),
          ),
        );

        //}

        return jsonDecode(response.body);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    gerCurrentLiveLocationOfUser();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markers,
            zoomControlsEnabled: false,
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                visible: true,
                width: 3,
                color: const Color.fromARGB(255, 18, 7, 212),
              ),
            },
            onMapCreated: (GoogleMapController mapController) {
              if (!googleMapCompleterController.isCompleted) {
                googleMapCompleterController.complete(mapController);
                controllerGoogleMap = mapController;
              }

              // mapProvider.controllerGoogleMap = mapController;

              // mapProvider.googleMapCompleterController
              //     .complete(mapProvider.controllerGoogleMap);
            },
            initialCameraPosition: googlePlexInitialPosition,
          ),
          Positioned(
            top: 30,
            left: 10,
            child: GestureDetector(
              onTap: () {
                getPickupData();
              },
              child: CustomButton(
                text: 'online',
                height: 55,
                width: 100,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
