import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/models/Driver.dart';
import 'package:taxia/views/started_trip/started_trip.dart';
import 'package:url_launcher/url_launcher.dart';

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

  late Uint8List customMarkerIcon;

  LatLng? driverLocation;

  LatLng? dropLoc;

  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  List<LatLng> polylineCordinates = [];

  Set<Marker> markers = Set<Marker>();

  GoogleMapController? controllerGoogleMap;

  Position? currentPositionOfUser;

  Uri? dialNumber;

  String? firstName;
  String? phoneNumber;
  String? driverID;

  bool isStartedTrip = false;

  @override
  void initState() {
    super.initState();
    loadCustomMaker();
    //getCurrentLiveLocationOfUser();

    getPickupData();

    //listn
    //markers.clear();
    listnToTheChanges();
  }

  navigateToTripStartedScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TripStarted(
          rideID: widget.rideID,
          userID: widget.userID,
          phoneNumber: phoneNumber!,
          firstName: firstName!,
          pickupLocation: widget.pickupLocation,
          dropLocation: dropLoc!,
        ),
      ),
    );
  }

  listnToTheChanges() {
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

                    if (tripData['isStarted'] == true) {
                      navigateToTripStartedScreen();
                    }
                    //isDriverInLocation = tripData['isStarted'];
                    print(driverLocation);

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

  callNumber() async {
    await launchUrl(dialNumber!);
  }

  @override
  void dispose() {
    super.dispose();
    cancelRide();
  }

  void cancelRide() async {
    try {
      DatabaseReference databaseReference =
          await FirebaseDatabase.instance.ref('ongoing_rides');

      databaseReference.child(widget.rideID).remove();
      print("Sucessfully Deleted!");
    } catch (e) {
      print(e);
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "You canceled the ride!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
        Navigator.pop(context);
      }
    }
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
          dialNumber = Uri(scheme: 'tel', path: phoneNumber);
        });
        return Driver.fromJson(driversDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print(e);
    } finally {
      print("Succesfully get data");
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

  void getPickupData() {
    markers.clear();
    databaseReference
        .child(widget.rideID)
        //.child('c5f50ff7-a5eb-435d-9b71-954c3e9276d7')
        .once()
        .then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;

        data.forEach((key, tripData) {
          if (tripData != null) {
            if (tripData is Map && tripData.containsKey('pickAddress')) {
              if (tripData['rideID'].toString() == widget.rideID) {
                setState(() {
                  driverID = tripData['driverID'].toString();
                  driverLocation = LatLng(
                      double.parse(tripData['picupLocationLat'].toString()),
                      double.parse(tripData['picupLocationLong'].toString()));
                  // firstName = tripData['pickAddress'].toString();
                  // driverLocation = LatLng(
                  //     double.parse(tripData['driverLocationLat'].toString()),
                  //     double.parse(tripData['driverLocationLon'].toString()));

                  // CameraPosition cameraPosition = CameraPosition(
                  //     target: LatLng(6.9060787, 79.96962769999999), zoom: 15);

                  // controllerGoogleMap!.animateCamera(
                  //     CameraUpdate.newCameraPosition(cameraPosition));
                  print(driverLocation);

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
                          double.parse(tripData['picupLocationLat'].toString()),
                          double.parse(
                              tripData['picupLocationLong'].toString())),
                      infoWindow: const InfoWindow(title: 'Driver Location'),
                    ),
                  );

                  //   drowPolylineRoute(LatLng(
                  //       double.parse(tripData['picupLocationLat'].toString()),
                  //       double.parse(tripData['picupLocationLong'].toString())));
                });

                drowPolylineRoute(
                  LatLng(double.parse(tripData['picupLocationLat'].toString()),
                      double.parse(tripData['picupLocationLong'].toString())),
                );
                getDriverData();
                print(markers);
                //drowMap();
                //print(driverLocation);

                //Mark in map

                // CameraPosition cameraPosition = CameraPosition(
                //     target: LatLng(
                //         double.parse(tripData['driverLocationLat'].toString()),
                //         double.parse(tripData['driverLocationLon'].toString())),
                //     zoom: 15);

                // controllerGoogleMap!.animateCamera(
                //     CameraUpdate.newCameraPosition(cameraPosition));
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

    // databaseReference
    //     .child('F4G3rBkZs4cT0Hup1nHNXq0L5sC2')
    //     .child('d013d045-17c3-44e1-9882-514da7accf2e')
    //     .onValue
    //     .listen((event) {
    //   setState(() {
    //     firstName = event.snapshot.value.toString();
    //   });
    //   print(firstName);
    // });
  }

  // void drowMap() async {
  //   markers.add(
  //     Marker(
  //       icon: BitmapDescriptor.defaultMarker,
  //       markerId: const MarkerId('pickup'),
  //       position: widget.pickupLocation,
  //       infoWindow: const InfoWindow(title: 'Pickup Location'),
  //     ),
  //   );

  //   markers.add(
  //     Marker(
  //       icon: BitmapDescriptor.defaultMarker,
  //       markerId: const MarkerId('driver'),
  //       position: driverLocation!,
  //       infoWindow: const InfoWindow(title: 'Driver Location'),
  //     ),
  //   );
  // }

  loadCustomMaker() async {
    customMarkerIcon = await loadAsset('assets/images/driverLoc.png', 150);
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

  void drowPolylineRoute(LatLng driverLoc) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
      PointLatLng(driverLoc.latitude, driverLoc.longitude),
      PointLatLng(
          widget.pickupLocation.latitude, widget.pickupLocation.longitude),
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
            initialCameraPosition: CameraPosition(
                target: driverLocation == null
                    ? widget.pickupLocation
                    : driverLocation!,
                zoom: 15),
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
                          cancelRide();
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
