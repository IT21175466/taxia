import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/map/map_provider.dart';

class InitialSplash extends StatefulWidget {
  const InitialSplash({super.key});

  @override
  State<InitialSplash> createState() => _InitialSplashState();
}

class _InitialSplashState extends State<InitialSplash> {
  @override
  void initState() {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    mapProvider.isLoading = true;
    mapProvider.getVehicleRates(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: AppColors.buttonColor,
        height: screenHeight,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Flego Taxi',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Loading infomation.....',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
