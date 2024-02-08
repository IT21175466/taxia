import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/widgets/custom_element.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? userId = '';

  //Ride
  String? rideID = '...';
  LatLng? pickup;
  LatLng? drop;
  String? vehicleType = '...';
  Double? totalKm;
  Double? totalPrice;
  String? pickAddress = '...';
  String? dropAddress = '...';
  String? scheduledTime = '...';
  String? scheduledDate = '...';

  bool isRecordAvailable = false;

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  getUserID() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('userID');
    });

    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref('sheduled_rides');

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map?;

      if (values != null) {
        values.forEach((key, rideData) {
          print('Key: $key');

          if (key == userId) {
            databaseReference.onValue.listen((event2) {
              DataSnapshot dataSnapshot2 = event2.snapshot.child(key);
              Map<dynamic, dynamic>? values2 = dataSnapshot2.value as Map?;

              if (values2 != null) {
                values2.forEach((key2, rideData2) {
                  print('Key2: $key2');

                  setState(() {
                    isRecordAvailable = true;
                    pickAddress = rideData2['pickupAddress'].toString();
                    dropAddress = rideData2['dropAddress'].toString();
                    vehicleType = rideData2['vehicleType'].toString();
                    scheduledTime = rideData2['time'].toString();
                    scheduledDate = rideData2['date'].toString();
                  });
                });
              }
            });
          } else {
            print('No Data');
          }

          // databaseReference.onValue.listen((event2) {
          //   DataSnapshot dataSnapshot2 = event2.snapshot.child(key);
          //   Map<dynamic, dynamic>? values2 = dataSnapshot2.value as Map?;

          //   if (values2 != null) {
          //     values2.forEach((key2, rideData2) {
          //       print('Key: $key2');

          //       if (key2 == userId) {
          //         setState(() {
          //           isRecordAvailable = true;
          //           pickAddress = rideData2['pickupAddress'].toString();
          //           dropAddress = rideData2['dropAddress'].toString();
          //           vehicleType = rideData2['vehicleType'].toString();
          //           scheduledTime = rideData2['time'].toString();
          //           scheduledDate = rideData2['date'].toString();
          //         });
          //       }
          //     });
          //   } else {
          //     print('No Data');
          //   }
          // });

          // if (rideData is Map &&
          //     rideData.containsKey('pickupAddress') &&
          //     rideData.containsKey('dropAddress') &&
          //     rideData.containsKey('vehicleType')) {
          // print('picupLocationLat: ${rideData['picupLocationLat']}');
          // print('picupLocationLong: ${rideData['picupLocationLong']}');

          print(rideData);
          // } else {
          //   print('Invalid data structure or missing values for key $key');
          // }
        });
      } else {
        setState(() {
          isRecordAvailable = false;
        });
      }
    });
  }

  void deleteRide() async {
    try {
      DatabaseReference databaseReference =
          await FirebaseDatabase.instance.ref('sheduled_rides');

      await databaseReference.child(userId!).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "You deleted the ride!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      print("Sucessfully Deleted!");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/map');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color.fromARGB(255, 14, 88, 216),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Where should I go?',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.grayColor,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    Text("Leave"),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "now",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down_outlined),
                  ],
                ),
                // TextField(
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(5.0),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //       borderSide: const BorderSide(
                //         color: Color.fromARGB(255, 14, 88, 216),
                //         width: 1,
                //       ),
                //     ),
                //     labelText: "Where should I go?",
                //     labelStyle: TextStyle(
                //       fontWeight: FontWeight.w500,
                //       color: AppColors.grayColor,
                //     ),
                //     suffixIcon: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //       child: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Text("Leave"),
                //           SizedBox(
                //             width: 5,
                //           ),
                //           Text(
                //             "now",
                //             style: TextStyle(
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //           Icon(Icons.arrow_drop_down_outlined),
                //         ],
                //       ),
                //     ),
                //     contentPadding: const EdgeInsets.symmetric(
                //         vertical: 16, horizontal: 10),
                //   ),
                // ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Icon(Icons.home_outlined),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Home",
                  style: TextStyle(),
                ),
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.work_outline),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Work",
                  style: TextStyle(),
                ),
              ],
            ),
            Visibility(
              visible: isRecordAvailable,
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blueAccent.withOpacity(0.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Sheduled Ride",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            deleteRide();
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Pickup - ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grayColor,
                          ),
                        ),
                        Text(
                          pickAddress!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Drop - ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grayColor,
                          ),
                        ),
                        Text(
                          dropAddress!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Date - ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grayColor,
                          ),
                        ),
                        Text(
                          scheduledDate!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Time - ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grayColor,
                          ),
                        ),
                        Text(
                          scheduledTime!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              //Tempory
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Taxi",
                      imagePath: 'assets/images/taxi.png',
                      onTap: () {
                        Navigator.pushNamed(context, '/map');
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Show All",
                      imagePath: 'assets/images/dots.png',
                      onTap: () {},
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Pet",
                    //   imagePath: 'assets/images/pet.png',
                    //   onTap: () {},
                    // ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Book Taxi",
                      imagePath: 'assets/images/bookTaxi.png',
                      onTap: () {
                        Navigator.pushNamed(context, '/booktaximap');
                      },
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Rent Car",
                    //   imagePath: 'assets/images/rentCar.png',
                    //   onTap: () {},
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Train",
                    //   imagePath: 'assets/images/train.png',
                    //   onTap: () {},
                    // ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Bike",
                      imagePath: 'assets/images/bike.png',
                      onTap: () {},
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Flight",
                    //   imagePath: 'assets/images/airplane.png',
                    //   onTap: () {},
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Charter bus",
                    //   imagePath: 'assets/images/charter.png',
                    //   onTap: () {},
                    // ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CustomElement(
                    //   label: "Parking",
                    //   imagePath: 'assets/images/parking.png',
                    //   onTap: () {},
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "EV Charge",
                    //   imagePath: 'assets/images/charging.png',
                    //   onTap: () {},
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),

                    CustomElement(
                      label: "XD",
                      imagePath: 'assets/images/delivery.png',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'This feature not available at this moment'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                //Spacer(),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     CustomElement(
                //       label: "Driver",
                //       imagePath: 'assets/images/driverElement.png',
                //       onTap: () {},
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     CustomElement(
                //       label: "Request",
                //       imagePath: 'assets/images/request.png',
                //       onTap: () {},
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     CustomElement(
                //       label: "Request",
                //       imagePath: 'assets/images/request.png',
                //       onTap: () {},
                //     ),
                //   ],
                // ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
