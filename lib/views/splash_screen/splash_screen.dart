import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/user/login_provider.dart';

class SplashScreen extends StatefulWidget {
  final String id;
  const SplashScreen({super.key, required this.id});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.checkUserIsSignUp(widget.id, context);
    //ckeckLoginSaved();
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
