import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/views/driver/driver_home/driver_info_page.dart';
import 'package:taxia/widgets/setting_card.dart';

class MyInfoDriver extends StatefulWidget {
  const MyInfoDriver({super.key});

  @override
  State<MyInfoDriver> createState() => _MyInfoDriverState();
}

class _MyInfoDriverState extends State<MyInfoDriver> {
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
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.accentColor,
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
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
              child: SettingCard(title: "My Info"),
            ),
            SettingCard(title: "Ride History"),
            SettingCard(title: "Language"),
          ],
        ),
      ),
    );
  }
}
