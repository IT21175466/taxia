import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TripStarted extends StatefulWidget {
  final String rideID;
  final String userID;
  final String phoneNumber;
  final String firstName;
  final LatLng pickupLocation;
  final LatLng dropLocation;
  const TripStarted({
    super.key,
    required this.rideID,
    required this.userID,
    required this.phoneNumber,
    required this.firstName,
    required this.pickupLocation,
    required this.dropLocation,
  });

  @override
  State<TripStarted> createState() => _TripStartedState();
}

class _TripStartedState extends State<TripStarted> {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('ongoing_rides');

  late Uint8List customMarkerIcon;
  List<LatLng> polylineCordinates = [];

  LatLng? driverLocation;

  LatLng? dropLoc;

  Set<Marker> markers = Set<Marker>();

  GoogleMapController? controllerGoogleMap;

  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  Uri? dialNumber;

  callNumber() async {
    await launchUrl(dialNumber!);
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
        position: widget.dropLocation,
        infoWindow: const InfoWindow(title: 'Driver Location'),
      ),
    );

    drowPolylineRoute();
  }

  void drowPolylineRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
      PointLatLng(widget.dropLocation.latitude, widget.dropLocation.longitude),
      PointLatLng(
          widget.pickupLocation.latitude, widget.pickupLocation.longitude),
    );
    if (this.mounted) {
      setState(() {
        polylineCordinates.clear();

        polylineResult.points.forEach(
          (PointLatLng points) => polylineCordinates.add(
            LatLng(points.latitude, points.longitude),
          ),
        );
      });
    }
  }

  loadCustomMaker() async {
    customMarkerIcon = await loadAsset('assets/images/taxiLoc.png', 150);
  }

  double radians(double degrees) {
    return degrees * (pi / 180.0);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    loadCustomMaker();
    drowMap();
    setState(() {
      dialNumber = Uri(scheme: 'tel', path: widget.phoneNumber);
    });

    databaseReference
        .child(widget.rideID)
        //.child('c5f50ff7-a5eb-435d-9b71-954c3e9276d7')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;

        data.forEach((key, tripData) {
          if (tripData != null) {
            if (tripData is Map && tripData.containsKey('pickAddress')) {
              if (tripData['rideID'].toString() == widget.rideID) {
                if (this.mounted) {
                  setState(() {
                    driverLocation = LatLng(
                        double.parse(tripData['picupLocationLat'].toString()),
                        double.parse(tripData['picupLocationLong'].toString()));

                    dropLoc = LatLng(
                        double.parse(tripData['dropLocationLat'].toString()),
                        double.parse(tripData['dropLocationLong'].toString()));

                    //isDriverInLocation = tripData['isStarted'];

                    if (tripData['isEnded'] == true) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    }

                    markers.clear();

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
                        icon: BitmapDescriptor.fromBytes(
                          customMarkerIcon,
                        ),
                        markerId: const MarkerId('driver'),
                        position: LatLng(
                            double.parse(
                                tripData['picupLocationLat'].toString()),
                            double.parse(
                                tripData['picupLocationLong'].toString())),
                        infoWindow: const InfoWindow(title: 'Driver Location'),
                      ),
                    );
                  });
                }
                print(markers);
              } else {
                print('Invalid Ride!!');
              }
            } else {
              print('Not Map');
            }
          } else {
            print('No pickAddress data for key $key');
          }
        });
      } else {
        print('No data available under the specified path.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCordinates,
                visible: true,
                width: 3,
                color: const Color.fromARGB(255, 18, 7, 212),
              ),
            },
            markers: markers,
            zoomControlsEnabled: false,
            initialCameraPosition:
                CameraPosition(target: widget.pickupLocation, zoom: 15),
            onMapCreated: (GoogleMapController controller) {
              if (!googleMapCompleterController.isCompleted) {
                googleMapCompleterController.complete(controller);
                controllerGoogleMap = controller;
                //customInfoWindowController.googleMapController = mapController;
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
                  Row(
                    children: [
                      Icon(Icons.home),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          //drowMap();
                          //getDriverData();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          callNumber();
                        },
                        child: Container(
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
                  Text(
                    widget.firstName,
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
