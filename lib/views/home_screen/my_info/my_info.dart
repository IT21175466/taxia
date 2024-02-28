import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/views/home_screen/my_info/info.dart';
import 'package:taxia/views/ride_history/users/user_ride_history.dart';
import 'package:taxia/widgets/setting_card.dart';

class MyInfoUser extends StatefulWidget {
  const MyInfoUser({super.key});

  @override
  State<MyInfoUser> createState() => _MyInfoUserState();
}

class _MyInfoUserState extends State<MyInfoUser> {
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
                    builder: (context) => InfoPage(),
                  ),
                );
              },
              child: SettingCard(title: "My Info"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserRideHistory(),
                  ),
                );
              },
              child: SettingCard(title: "Ride History"),
            ),
            SettingCard(title: "Language"),
          ],
        ),
      ),
    );
  }
}
