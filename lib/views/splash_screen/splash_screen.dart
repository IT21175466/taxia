import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ckeckLoginSaved();
  }

  ckeckLoginSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final checkLogin = prefs.getBool('logedIn') ?? false;

    checkLogin
        ? Navigator.pushReplacementNamed(context, '/home')
        : Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Welcome to Taxia',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
            Text(
              'Loading infomation.....',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
