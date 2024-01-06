import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:geocoding/geocoding.dart';

class AcceptRide extends StatefulWidget {
  final String driverID;
  final String rideID;
  final String passengerID;
  final LatLng pickupLatLon;
  final LatLng driverLatLon;
  final double distance;
  final String timeDuration;
  final double dropLoationLat;
  final double dropLoationLon;
  final String selectedVehicle;
  final double totalPrice;
  final double totalKM;

  const AcceptRide({
    super.key,
    required this.rideID,
    required this.passengerID,
    required this.pickupLatLon,
    required this.driverLatLon,
    required this.distance,
    required this.timeDuration,
    required this.dropLoationLat,
    required this.dropLoationLon,
    required this.selectedVehicle,
    required this.totalPrice,
    required this.totalKM,
    required this.driverID,
  });

  @override
  State<AcceptRide> createState() => _AcceptRideState();
}

class _AcceptRideState extends State<AcceptRide> {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('ongoing_rides');

  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  List<LatLng> polylineCordinates = [];

  Set<Marker> markers = Set<Marker>();

  String? dropLocation;

  GoogleMapController? controllerGoogleMap;

  @override
  void initState() {
    super.initState();
    print(widget.driverLatLon);
    print(widget.pickupLatLon);
    getAddresses();
    drowMap();
  }

  getAddresses() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.dropLoationLat, widget.dropLoationLon);

    setState(() {
      dropLocation = placemarks.reversed.last.locality.toString() +
          ", " +
          placemarks.reversed.first.country.toString();
    });
  }

  void deleteRequest() async {
    try {
      DatabaseReference databaseReference =
          await FirebaseDatabase.instance.ref('rides');

      databaseReference.child(widget.rideID).remove();
      print("Sucessfully Deleted! : ${widget.rideID}");
    } catch (e) {
      print(e);
    }
  }

  void drowMap() async {
    markers.add(
      Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId('pickup'),
        position: widget.pickupLatLon,
        infoWindow: const InfoWindow(title: 'Pickup Location'),
      ),
    );

    markers.add(
      Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId('driver'),
        position: widget.driverLatLon,
        infoWindow: const InfoWindow(title: 'Driver Location'),
      ),
    );

    drowPolyline();
  }

  void drowPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
      PointLatLng(widget.driverLatLon.latitude, widget.driverLatLon.longitude),
      PointLatLng(widget.pickupLatLon.latitude, widget.pickupLatLon.longitude),
    );

    setState(() {
      polylineCordinates.clear();

      polylineResult.points.forEach(
        (PointLatLng points) => polylineCordinates.add(
          LatLng(points.latitude, points.longitude),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            zoomControlsEnabled: false,
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCordinates,
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
            initialCameraPosition:
                CameraPosition(target: widget.driverLatLon, zoom: 15),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.accentColor,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "In ${widget.timeDuration}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${widget.distance} Km",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.grayColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Drop - $dropLocation",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Text(
                  //   "From ${widget.fromText}",
                  //   style: TextStyle(
                  //     fontSize: 15,
                  //     color: AppColors.grayColor,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),

                  GestureDetector(
                    onTap: () async {
                      await databaseReference.child(widget.rideID).set({
                        "driverID": widget.driverID,
                        "rideID": widget.rideID,
                        "pID": widget.passengerID,
                        "picupLocationLong": widget.pickupLatLon.longitude,
                        "picupLocationLat": widget.pickupLatLon.latitude,
                        "dropLocationLong": widget.dropLoationLon,
                        "dropLocationLat": widget.dropLoationLat,
                        "vehicleType": widget.selectedVehicle,
                        "totalKm": widget.distance,
                        "totalPrice": widget.totalPrice,
                        "driverLocationLat": widget.driverLatLon.latitude,
                        "driverLocationLon": widget.driverLatLon.longitude,
                      });
                      deleteRequest();
                    },
                    child: Container(
                      height: 55,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Accept',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.navigation_rounded),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
