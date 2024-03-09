import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/user/user_provider.dart';
import 'package:taxia/views/driver/goto_passenger_location/goto_passenger.dart';

class AcceptRide extends StatefulWidget {
  final String driverID;
  final String rideID;
  final String passengerID;
  final LatLng pickupLatLon;
  final LatLng driverLatLon;
  final String distance;
  final String timeDuration;
  final double dropLoationLat;
  final double dropLoationLon;
  final String selectedVehicle;
  final double totalPrice;
  final double totalKM;
  final String pickAddress;
  final String dropAddress;

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
    required this.pickAddress,
    required this.dropAddress,
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

  GoogleMapController? controllerGoogleMap;

  String? totalAmount;

  @override
  void initState() {
    super.initState();
    drowMap();
    setState(() {
      totalAmount = widget.totalPrice.toStringAsFixed(2);
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.getDriverCoupens();
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

  // checkRideAvailability(String rID) async {
  //   DatabaseReference databaseReferenceRides =
  //       await FirebaseDatabase.instance.ref('rides');

  //   databaseReferenceRides.child(rID).onValue.listen((event) {
  //     DataSnapshot dataSnapshot = event.snapshot;
  //     Map<dynamic, dynamic>? values = dataSnapshot.value as Map?;

  //     if (values != null) {
  //       print('Data available under "rides" node.');
  //     } else {
  //       print('No data found under "rides" node.');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder:
            (BuildContext context, UserProvider userProvider, Widget? child) =>
                Stack(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            height: 80,
                            child: Image.asset('assets/images/avator.png')),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "In ${widget.timeDuration}",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "LKR $totalAmount",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          "${widget.distance}",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.grayColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pickup point",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "${widget.pickAddress}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Drop point",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "${widget.dropAddress}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                      height: 30,
                    ),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            height: 55,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 248, 61, 61),
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
                                    'Decline',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.close),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            await userProvider.getDriverCoupens();

                            if (userProvider.noCoupens == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "You have no coupens to accept this ride!!",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              DatabaseReference databaseReferenceRides =
                                  await FirebaseDatabase.instance.ref('rides');

                              DatabaseEvent event = await databaseReferenceRides
                                  .child(widget.rideID)
                                  .once();

                              if (event.snapshot.value != null) {
                                print('Data available under "rides" node.');
                                await databaseReference
                                    .child(widget.rideID)
                                    .child(widget.driverID)
                                    .set({
                                  "driverID": widget.driverID,
                                  "rideID": widget.rideID,
                                  "pID": widget.passengerID,
                                  "picupLocationLong":
                                      widget.pickupLatLon.longitude,
                                  "picupLocationLat":
                                      widget.pickupLatLon.latitude,
                                  "dropLocationLong": widget.dropLoationLon,
                                  "dropLocationLat": widget.dropLoationLat,
                                  "vehicleType": widget.selectedVehicle,
                                  "totalKm": widget.distance,
                                  "totalPrice": widget.totalPrice,
                                  "driverLocationLat":
                                      widget.driverLatLon.latitude,
                                  "driverLocationLon":
                                      widget.driverLatLon.longitude,
                                  "pickAddress": widget.pickAddress,
                                  "dropAddress": widget.dropAddress,
                                  "isStarted": false,
                                  "isEnded": false,
                                });

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GoToPassenger(
                                      driverID: widget.driverID,
                                      rideID: widget.rideID,
                                      passengerID: widget.passengerID,
                                      pickupLatLon: widget.pickupLatLon,
                                      driverLatLon: widget.driverLatLon,
                                      pickAddress: widget.pickAddress,
                                      dropAddress: widget.dropAddress,
                                      totalPrice: widget.totalPrice,
                                      totalKM: widget.totalKM,
                                      selectedVehicle: widget.selectedVehicle,
                                    ),
                                  ),
                                );
                              } else {
                                print('No data found under "rides" node.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Ride not Available!"),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            height: 55,
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
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
