import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/views/coupens/driver/driver_coupen_page.dart';
import 'package:taxia/views/driver/driver_home/driver_info_page.dart';
import 'package:taxia/views/ride_history/drivers/driver_ride_history.dart';
import 'package:taxia/widgets/setting_card.dart';

class MyInfoDriver extends StatefulWidget {
  const MyInfoDriver({super.key});

  @override
  State<MyInfoDriver> createState() => _MyInfoDriverState();
}

class _MyInfoDriverState extends State<MyInfoDriver> {
  String? driverID = '';

  @override
  void initState() {
    getDriverID();
    super.initState();
  }

  getDriverID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      driverID = prefs.getString('userID');
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.accentColor,
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverInfoPage(),
                  ),
                );
              },
              child: SettingCard(
                title: "My Info",
                icon: 'assets/images/myInfo.png',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverCoupenPage(
                      driverId: driverID!,
                    ),
                  ),
                );
              },
              child: SettingCard(
                title: "Coupens",
                icon: 'assets/images/coupens.png',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverRideHistory(),
                  ),
                );
              },
              child: SettingCard(
                title: "Ride History",
                icon: 'assets/images/rideHistory.png',
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => UserRideHistory(),
                //   ),
                // );
              },
              child: SettingCard(
                title: "Contact us",
                icon: 'assets/images/contactUS.png',
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.accentColor,
    );
  }
}
