import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/models/ride.dart';
import 'package:taxia/providers/ride/ride_provider.dart';
import 'package:taxia/views/rating_screen/driver_rating.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart' as loc;

class StartTrip extends StatefulWidget {
  final String driverID;
  final String rideID;
  final String firstName;
  final String phoneNumber;
  final String passengerID;
  final LatLng pickupLatLon;
  final LatLng driverLatLon;
  final String pickAddress;
  final String dropAddress;
  final double totalPrice;
  final double totalKM;
  final String selectedVehicle;
  const StartTrip(
      {super.key,
      required this.driverID,
      required this.rideID,
      required this.firstName,
      required this.phoneNumber,
      required this.passengerID,
      required this.pickupLatLon,
      required this.driverLatLon,
      required this.pickAddress,
      required this.dropAddress,
      required this.totalPrice,
      required this.totalKM,
      required this.selectedVehicle});

  @override
  State<StartTrip> createState() => _StartTripState();
}

class _StartTripState extends State<StartTrip> {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('ongoing_rides');

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  LatLng? dropLoc;
  bool isStarted = false;
  String? totalAmount;
  String? totalKms;

  // String? driverIID;
  // String? dropAddress;
  // String? pickAddress;
  // String? totalKM;
  // double? totalPrice;
  // String? vehicleType;

  Uri? dialNumber;

  @override
  void initState() {
    _listenLocation();
    super.initState();
    //getPickupData();
    setState(() {
      totalAmount = widget.totalPrice.toStringAsFixed(2);
      totalKms = widget.totalKM.toStringAsFixed(1);
      dialNumber = Uri(scheme: 'tel', path: widget.phoneNumber);
    });
  }

  callNumber() async {
    await launchUrl(dialNumber!);
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();

      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      await databaseReference
          .child(widget.rideID)
          .child(widget.driverID)
          .update({
        "driverLocationLat": currentLocation.latitude,
        "driverLocationLon": currentLocation.longitude,
      });
    });
  }

  // void getPickupData() async {
  //   await databaseReference
  //       .child(widget.rideID)
  //       //.child('c5f50ff7-a5eb-435d-9b71-954c3e9276d7')
  //       .once()
  //       .then((event) {
  //     if (event.snapshot.value != null) {
  //       Map<dynamic, dynamic> data = event.snapshot.value as Map;

  //       data.forEach((key, tripData) {
  //         if (tripData != null) {
  //           if (tripData is Map && tripData.containsKey('pickAddress')) {
  //             if (tripData['rideID'].toString() == widget.rideID) {
  //               setState(() {
  //                 dropLoc = LatLng(
  //                     double.parse(tripData['dropLocationLat'].toString()),
  //                     double.parse(tripData['dropLocationLong'].toString()));

  //                 //tripData['driverID'].toString();
  //                 // driverLocation = LatLng(
  //                 //     double.parse(tripData['picupLocationLat'].toString()),
  //                 //     double.parse(tripData['picupLocationLong'].toString()));

  //                 //New
  //                 tripData['driverID'] = driverIID;
  //                 tripData['dropAddress'] = dropAddress;
  //                 tripData['pickAddress'] = pickAddress;
  //                 tripData['pickAddress'] = pickAddress;
  //                 totalKM = tripData['totalKm'];
  //                 totalPrice = double.parse(tripData['totalPrice'].toString());
  //                 tripData['vehicleType'] = pickAddress;
  //               });
  //             } else {
  //               print('Invalid Ride!!');
  //             }
  //           } else {
  //             print('Not Map');
  //           }
  //         } else {
  //           print('No pickAddress data for key $key');
  //         }
  //       });
  //     } else {
  //       print('No data available under the specified path.');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer(
        builder:
            (BuildContext context, RideProvider rideProvider, Widget? child) =>
                Container(
          width: screenWidth,
          height: screenHeight,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: AppBar().preferredSize.height,
              ),
              isStarted
                  ? const Text(
                      'You Started The Trip',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    )
                  : const Text(
                      'Ready To Start The Trip',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: const Center(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.firstName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.person,
                          color: AppColors.grayColor,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.phoneNumber,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            callNumber();
                          },
                          child: Icon(
                            Icons.phone,
                            color: AppColors.grayColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(
                              'google.navigation:q=${widget.dropAddress}&key=AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY'),
                        );
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Navigate to drop Location',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textColor,
                            ),
                          ),
                          Spacer(),
                          // loading
                          //     ? SizedBox(
                          //         height: 30,
                          //         width: 30,
                          //         child: CircularProgressIndicator(),
                          //       )
                          //     :
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

              //Ride Details
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Ride Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  border: Border.all(
                    color: AppColors.grayColor,
                    width: 0.3,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Pick - ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          widget.pickAddress,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Drop - ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          widget.dropAddress,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Total KM - ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          '$totalKms KM',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Total Price - ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          'Rs. $totalAmount',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              isStarted
                  ? Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                await databaseReference
                                    .child(widget.rideID)
                                    .child(widget.driverID)
                                    .update({
                                  "isEnded": true,
                                });

                                _locationSubscription!.cancel();
                                await rideProvider.confirmRide(
                                  Ride(
                                    rideID: widget.rideID,
                                    passengerID: widget.passengerID,
                                    picupLocation: const LatLng(0, 0),
                                    dropLocation: const LatLng(0, 0),
                                    vehicleType: widget.selectedVehicle,
                                    totalKMs: widget.totalKM,
                                    totalPrice: widget.totalPrice,
                                    dropAddresss: widget.pickAddress,
                                    pickupAddress: widget.dropAddress,
                                    date: DateTime.now().toString(),
                                    driverID: widget.driverID,
                                    ratingComment: '',
                                    ratingStars: 0.0,
                                  ),
                                  widget.passengerID,
                                  context,
                                  widget.rideID,
                                );
                                await rideProvider.confirmRideToDriver(
                                  Ride(
                                    rideID: widget.rideID,
                                    passengerID: widget.passengerID,
                                    picupLocation: const LatLng(0, 0),
                                    dropLocation: const LatLng(0, 0),
                                    vehicleType: widget.selectedVehicle,
                                    totalKMs: widget.totalKM,
                                    totalPrice: widget.totalPrice,
                                    dropAddresss: widget.pickAddress,
                                    pickupAddress: widget.dropAddress,
                                    date: DateTime.now().toString(),
                                    driverID: widget.driverID,
                                    ratingStars: 0.0,
                                    ratingComment: '',
                                  ),
                                  widget.driverID,
                                  context,
                                  widget.rideID,
                                );
                              } catch (e) {
                                print(e);
                              } finally {
                                databaseReference
                                    .child(widget.rideID)
                                    .child(widget.driverID)
                                    .remove();

                                rideProvider.loading = false;

                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DriverRating(passengerID: widget.passengerID, rideID: widget.rideID, firstName: widget.firstName, progileImage: '',)));
                              }
                            },
                            child: rideProvider.loading
                                ? const SizedBox(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : CustomButton(
                                    text: "End Trip",
                                    height: 55,
                                    width: screenWidth,
                                    backgroundColor:
                                        const Color.fromARGB(250, 225, 105, 0),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: CustomButton(
                            text: "Break",
                            height: 55,
                            width: screenWidth,
                            backgroundColor: AppColors.buttonColor,
                          ),
                        )
                      ],
                    )
                  : GestureDetector(
                      onTap: () async {
                        setState(() {
                          isStarted = true;
                        });

                        await databaseReference
                            .child(widget.rideID)
                            .child(widget.driverID)
                            .update({
                          "isStarted": true,
                        });
                      },
                      child: CustomButton(
                        text: "Start Trip",
                        height: 55,
                        width: screenWidth,
                        backgroundColor: AppColors.buttonColor,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
