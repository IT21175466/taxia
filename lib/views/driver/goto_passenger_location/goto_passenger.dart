import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class GoToPassenger extends StatefulWidget {
  final String driverID;
  final String rideID;
  final String passengerID;
  final LatLng pickupLatLon;
  final LatLng driverLatLon;
  final String pickAddress;
  final String dropAddress;
  const GoToPassenger(
      {super.key,
      required this.driverID,
      required this.rideID,
      required this.passengerID,
      required this.pickupLatLon,
      required this.driverLatLon,
      required this.pickAddress,
      required this.dropAddress});

  @override
  State<GoToPassenger> createState() => _GoToPassengerState();
}

class _GoToPassengerState extends State<GoToPassenger> {
  String? firstName;
  String? phoneNumber;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    deleteRequest();
    getUserData();
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

  getUserData() async {
    try {
      final DocumentSnapshot usersDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.passengerID)
          .get();

      if (usersDoc.exists) {
        print(usersDoc);
        setState(() {
          firstName = usersDoc.get('FirstName').toString();
          phoneNumber = usersDoc.get('PhoneNumber').toString();
        });
        return User.fromJson(usersDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height,
            ),
            Text(
              'You Started The Trip',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Text(
                  'Passenger Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                border: Border.all(
                  color: AppColors.grayColor,
                  width: 0.3,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      firstName == null
                          ? Text('...')
                          : Text(
                              firstName!,
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textColor,
                              ),
                            ),
                      Spacer(),
                      Icon(
                        Icons.person,
                        color: AppColors.grayColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      phoneNumber == null
                          ? Text('...')
                          : Text(
                              phoneNumber!,
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textColor,
                              ),
                            ),
                      Spacer(),
                      Icon(
                        Icons.phone,
                        color: AppColors.grayColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(
                            'google.navigation:q=${widget.pickAddress}&key=AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY'),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Navigate',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigation,
                          color: AppColors.grayColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SwipeableButtonView(
              buttonText: "I'm In Location",
              buttontextstyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              buttonWidget: Container(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                ),
              ),
              activeColor: Color(0xFF009C41),
              isFinished: isFinished,
              onWaitingProcess: () {
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    isFinished = true;
                  });
                });
              },
              onFinish: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
