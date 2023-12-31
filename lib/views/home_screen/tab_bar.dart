import 'package:flutter/material.dart';
import 'package:taxia/views/home_screen/home_tab.dart';
import 'package:taxia/views/home_screen/my_car_tab.dart';
import 'package:taxia/widgets/custom_tab_indicator.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue,
                  Colors.purple,
                ],
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 10.0,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: ArrowTabBarIndicator(color: Colors.white),
            // BoxDecoration(
            //   borderRadius: BorderRadius.vertical(
            //     top: Radius.circular(10),
            //   ),
            //   color: Colors.white,
            // ),
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            labelStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(
                text: "Home",
              ),
              Tab(
                text: "My Car",
              ),

              // Tab(
              //   text: "Travel",
              // ),
            ],
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: const TabBarView(
          children: [
            HomeTab(),
            MyCarTab(),
            //TravelTab(),
          ],
        ),
      ),
    );
  }
}
