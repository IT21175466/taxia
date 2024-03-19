import 'package:flutter/material.dart';
import 'package:taxia/widgets/custom_button.dart';

class DriverRedAlertPage extends StatefulWidget {
  final String rideID;
  final String passengerID;
  final String alertID;
  final String driverIID;
  final String alertLocationLong;
  final String alertLocationLat;
  final String vehicleNumber;
  final double driverLocLatitude;
  final double driverLocLongitude;
  final String distance;
  final String timeDuration;
  const DriverRedAlertPage(
      {super.key,
      required this.rideID,
      required this.passengerID,
      required this.alertID,
      required this.driverIID,
      required this.alertLocationLong,
      required this.alertLocationLat,
      required this.vehicleNumber,
      required this.driverLocLatitude,
      required this.driverLocLongitude,
      required this.distance,
      required this.timeDuration});

  @override
  State<DriverRedAlertPage> createState() => _DriverRedAlertPageState();
}

class _DriverRedAlertPageState extends State<DriverRedAlertPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
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
              "Red Alert....",
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
              "Your nearby passenger requesting a help!",
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
            Row(
              children: [
                CustomButton(
                  text: 'Accept',
                  height: 55,
                  width: screenWidth / 2 - 50,
                  backgroundColor: Colors.green,
                ),
                Spacer(),
                CustomButton(
                  text: 'Decline',
                  height: 55,
                  width: screenWidth / 2 - 50,
                  backgroundColor: Colors.red,
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
