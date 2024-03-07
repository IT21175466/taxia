import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/providers/home/bootom_nav_bar_provider.dart';
import 'package:taxia/views/driver/driver_home/driver_home_tab.dart';
import 'package:taxia/views/driver/driver_home/my_info_driver.dart';
import 'package:taxia/widgets/bottom_nav_bar.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  //Tab Bar
  final List<Widget> pages = [
    DriverHomeTab(),
    // Center(
    //   child: Text("Business"),
    // ),
    // Center(
    //   child: Text("Notifications"),
    // ),
    MyInfoDriver(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context,
              BottomNavBarProvider bottomNavigationProvider, Widget? child) =>
          Scaffold(
        body: IndexedStack(
          index: bottomNavigationProvider.currentIndex,
          children: pages,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
