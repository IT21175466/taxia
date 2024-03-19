import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/views/home_screen/home_tab.dart';
import 'package:taxia/widgets/circle_Indicator.dart';
//import 'package:taxia/views/home_screen/my_car_tab.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        initialIndex: 0,
        //length: 2,
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: AppColors.accentColor,
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Color.fromARGB(255, 243, 243, 59),
                //     Color.fromARGB(255, 227, 227, 42),
                //   ],
                // ),
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 15.0,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: DotIndicator(),
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              labelStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(
                  text: "Home",
                ),
                // Tab(
                //   text: "My Car",
                // ),
              ],
            ),
            backgroundColor: Colors.blueAccent,
          ),
          body: const TabBarView(
            children: [
              HomeTab(),
              //MyCarTab(),
              //TravelTab(),
            ],
          ),
          backgroundColor: AppColors.accentColor,
        ),
      ),
    );
  }
}
