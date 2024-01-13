import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/global/global.dart';
import 'package:taxia/models/Driver.dart';

class RideAccepted extends StatefulWidget {
  final String rideID;
  final String userID;
  final LatLng pickupLocation;
  const RideAccepted({
    super.key,
    required this.rideID,
    required this.userID,
    required this.pickupLocation,
  });

  @override
  State<RideAccepted> createState() => _RideAcceptedState();
}

class _RideAcceptedState extends State<RideAccepted> {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('ongoing_rides');

  LatLng? driverLocation;

  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  List<LatLng> polylineCordinates = [];

  Set<Marker> markers = Set<Marker>();

  GoogleMapController? controllerGoogleMap;

  Position? currentPositionOfUser;

  String? firstName;
  String? phoneNumber;
  String? driverID;

  @override
  void initState() {
    super.initState();
    //getCurrentLiveLocationOfUser();
    getRideInfo(widget.rideID);
    getDriverData();
  }

  getDriverData() async {
    try {
      final DocumentSnapshot driversDoc = await FirebaseFirestore.instance
          .collection("Drivers")
          .doc(driverID)
          .get();

      if (driversDoc.exists) {
        setState(() {
          firstName = driversDoc.get('firstName').toString();
          phoneNumber = driversDoc.get('telephone').toString();
        });
        return Driver.fromJson(driversDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print(e);
    }
  }

  // getCurrentLiveLocationOfUser() async {
  //   Position positionOfUser = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);

  //   currentPositionOfUser = positionOfUser;

  //   LatLng positionOfUserInLatLng = LatLng(
  //       currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
  //   setState(() {
  //     CameraPosition cameraPosition =
  //         CameraPosition(target: positionOfUserInLatLng, zoom: 45);

  //     controllerGoogleMap!
  //         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //   });
  // }

  getRideInfo(String rID) async {
    databaseReference.child(rID).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map?;

      if (values != null) {
        values.forEach((key, rideData) {
          print('Key: $key');

          if (rideData is Map) {
            setState(() {
              rideData['driverLocationLat'] = driverLocation!.latitude;
              rideData['driverLocationLon'] = driverLocation!.longitude;
              rideData['driverID'] = driverID!;
            });
          } else {
            print('Invalid data structure or missing values for key $key');
          }
        });
      } else {
        print('No data found under "rides" node.');
      }
    });
  }

  void drowMap() async {
    markers.add(
      Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId('pickup'),
        position: widget.pickupLocation,
        infoWindow: const InfoWindow(title: 'Pickup Location'),
      ),
    );

    markers.add(
      Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId('driver'),
        //position: widget.driverLatLon,
        infoWindow: const InfoWindow(title: 'Driver Location'),
      ),
    );

    //drowPolyline();
  }

  // void drowPolyline() async {
  //   PolylinePoints polylinePoints = PolylinePoints();

  //   PolylineResult polylineResult =
  //       await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
  //     PointLatLng(widget.driverLatLon.latitude, widget.driverLatLon.longitude),
  //     PointLatLng(widget.pickupLatLon.latitude, widget.pickupLatLon.longitude),
  //   );

  //   setState(() {
  //     polylineCordinates.clear();

  //     polylineResult.points.forEach(
  //       (PointLatLng points) => polylineCordinates.add(
  //         LatLng(points.latitude, points.longitude),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            zoomControlsEnabled: false,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController controller) {
              if (!googleMapCompleterController.isCompleted) {
                googleMapCompleterController.complete(controller);
              }
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height - 15,
                left: 15,
                right: 15,
                bottom: 15,
              ),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.home),
                      Spacer(),
                      Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.grayColor,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.call),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.grayColor,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.man),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.grayColor,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.message),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  firstName == null
                      ? Text(
                          '...',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.grayColor,
                            fontSize: 18,
                          ),
                        )
                      : Text(
                          firstName!,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.grayColor,
                            fontSize: 18,
                          ),
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 232, 22),
                    ),
                    child: const Text(
                      "Emergency - 1334",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
