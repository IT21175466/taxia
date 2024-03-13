import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/views/home_screen/home_page.dart';
import 'package:taxia/views/rating_screen/user_rating.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class TripStarted extends StatefulWidget {
  final String rideID;
  final String userID;
  final String phoneNumber;
  final String firstName;
  final LatLng pickupLocation;
  final LatLng dropLocation;
  final String vehicleNumber;
  final String progileImage;
  final String driverID;
  const TripStarted({
    super.key,
    required this.rideID,
    required this.userID,
    required this.phoneNumber,
    required this.firstName,
    required this.pickupLocation,
    required this.dropLocation,
    required this.vehicleNumber,
    required this.progileImage,
    required this.driverID,
  });

  @override
  State<TripStarted> createState() => _TripStartedState();
}

class _TripStartedState extends State<TripStarted>
    with TickerProviderStateMixin {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('ongoing_rides');

  DatabaseReference databaseReferenceRedAlerts =
      FirebaseDatabase.instance.ref('redAlerts');

  bool isRedAlertEnable = false;

  //Get Current Position
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openAppSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      alertLocation = LatLng(position.latitude, position.longitude);
    });
  }

  // late final _animController = AnimationController(
  //   vsync: this,
  //   duration: Duration(seconds: 2),
  // )..repeat(reverse: true);

  // late final Animation<double> _animation = CurvedAnimation(
  //   parent: _animController,
  //   curve: Curves.easeIn,
  // );

  // @override
  // void dispose() {
  //   super.dispose();
  //   _animController.dispose();
  // }

  LatLng? alertLocation;

  String alertID = '';

  generatealertID() {
    setState(() {
      alertID = Uuid().v4();
    });
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
        Navigator.pushNamedAndRemoveUntil(context, '/map', (route) => false);
      }
    }
  }

  void redAlertInfoAlertDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(
            "Red Alert Service",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          content: Text(
            "Do you want to use Red Alert service?",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                //Navigator.of(ctx).pop();
              },
              child: const Text(
                "YES",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                "NO",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Red Alert Service",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          content: Text(
            "Do you want to use Red Alert service?",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {
                  isRedAlertEnable = true;
                });
                Navigator.of(ctx).pop();
                await _determinePosition();
                await generatealertID();
                databaseReferenceRedAlerts.child(alertID).set({
                  "alertID": widget.rideID,
                  "rideID": widget.rideID,
                  "passengerID": widget.userID,
                  "driver_ID": widget.driverID,
                  "alertLocationLong": alertLocation!.longitude,
                  "alertLocationLat": alertLocation!.latitude,
                  "vehicle_Number": widget.vehicleNumber,
                });
              },
              child: const Text(
                "YES",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                "NO",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

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
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/home', (route) => false);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserRating(
                            driverID: widget.driverID,
                            rideID: widget.rideID,
                            firstName: widget.firstName,
                            vehicleNumber: widget.vehicleNumber,
                            progileImage: widget.progileImage,
                          ),
                        ),
                      );
                    }

                    markers.clear();

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        child: Icon(Icons.home),
                      ),
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
                    child: Text(
                      widget.vehicleNumber,
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
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.red,
                border: Border.all(
                  color: Colors.red,
                ),
              ),
              child: GestureDetector(
                onLongPress: () {
                  redAlertInfoAlertDialog();
                },
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.accentColor,
                      content: Text(
                        "Long press to active Red Alert service.",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Red Alert",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isRedAlertEnable
              ? Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: screenWidth,
                    height: screenHeigth,
                    color: Colors.red.withOpacity(0.85),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        // FadeTransition(
                        //   opacity: _animation,
                        //   child: Container(
                        //     height: 250,
                        //     width: 250,
                        //     decoration: BoxDecoration(
                        //       //color: Colors.white,
                        //       borderRadius: BorderRadius.circular(100),
                        //       border: Border.all(
                        //         color: Colors.white,
                        //         width: 3,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Calling Red Alert....",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Your nearby and flego taxi will see your \nrequested help",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isRedAlertEnable = false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: CustomButton(
                                text: "I'm Safe",
                                height: 50,
                                width: screenWidth,
                                backgroundColor: Colors.white),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
