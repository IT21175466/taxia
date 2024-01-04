import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:taxia/constants/app_colors.dart';

class SearchDriver extends StatefulWidget {
  final String rideID;
  final String userID;
  final LatLng pickupLocation;
  final String selectedVehicle;

  const SearchDriver({
    super.key,
    required this.pickupLocation,
    required this.selectedVehicle,
    required this.userID,
    required this.rideID,
  });

  @override
  State<SearchDriver> createState() => _SearchDriverState();
}

class _SearchDriverState extends State<SearchDriver> {
  bool isLoading = false;
  double _progressValue = 1.0;
  final db = FirebaseFirestore.instance;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const duration = Duration(minutes: 1);
    int totalSeconds = duration.inSeconds;

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _progressValue = t.tick / totalSeconds;
      });

      if (t.tick >= totalSeconds) {
        t.cancel();
        timer =
            null; // Set timer to null after canceling to indicate that it's not active.
      }
    });
  }

  void cancelRide() async {
    try {
      DatabaseReference databaseReference =
          await FirebaseDatabase.instance.ref('rides');
      db
          .collection("Rides")
          .doc(widget.userID)
          .collection("Users")
          .doc(widget.rideID)
          .delete();

      databaseReference.child(widget.rideID).remove();
      print("Sucessfully Deleted!");
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
      timer!.cancel();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition camaraPlexInitialPosition = CameraPosition(
      target: LatLng(
          widget.pickupLocation.latitude, widget.pickupLocation.longitude),
      zoom: 15,
    );

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: {
              Marker(
                icon: BitmapDescriptor.defaultMarker,
                markerId: MarkerId('start'),
                position: widget.pickupLocation,
                infoWindow: InfoWindow(title: 'Start Location'),
              ),
            },
            zoomControlsEnabled: false,
            initialCameraPosition: camaraPlexInitialPosition,
          ),
          Positioned(
            left: 20,
            top: AppBar().preferredSize.height - 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: AppBar().preferredSize.height - 15,
            child: GestureDetector(
              onTap: () {
                isLoading = true;
                cancelRide();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 246, 244, 244),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.selectedVehicle == 'car')
                              Column(
                                children: [
                                  Text("Car"),
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset('assets/images/car.png'),
                                  ),
                                ],
                              )
                            else if (widget.selectedVehicle == 'bike')
                              Column(
                                children: [
                                  Text("Bike"),
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset(
                                        'assets/images/bikeSelect.png'),
                                  ),
                                ],
                              )
                            else if (widget.selectedVehicle == 'tuk')
                              Column(
                                children: [
                                  Text("Tuk"),
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset('assets/images/tuk.png'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Searching drivers....",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: lottie.Lottie.asset(
                                      'assets/animations/search_anim.json',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              LinearProgressIndicator(
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(5),
                                value: _progressValue,
                                backgroundColor:
                                    const Color.fromARGB(255, 222, 222, 222),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: Platform.isIOS ? 15 : null,
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
