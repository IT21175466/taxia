import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/providers/home/bootom_nav_bar_provider.dart';
import 'package:taxia/views/home_screen/my_info/my_info.dart';
import 'package:taxia/widgets/bottom_nav_bar.dart';
import 'package:taxia/views/home_screen/tab_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Tab Bar
  final List<Widget> pages = [
    MyTabBar(),
    // Center(
    //   child: Text("Business"),
    // ),
    // Center(
    //   child: Text("Notifications"),
    // ),
    MyInfoUser(),
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
