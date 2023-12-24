import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/providers/home/bootom_nav_bar_provider.dart';
import 'package:taxia/widgets/bottom_nav_bar.dart';
import 'package:taxia/widgets/tab_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Tab Bar
  final List<Widget> pages = [
    MyTabBar(),
    Center(
      child: Text("Business"),
    ),
    Center(
      child: Text("Notifications"),
    ),
    Center(
      child: Text("My Info"),
    ),
  ];
  @override
  void initState() {
    super.initState();
    getUserID();
  }

  String? id = '';

  void getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('userID');
    });
  }

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
