import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/views/home_screen/home_tab.dart';
import 'package:taxia/views/home_screen/my_car_tab.dart';
import 'package:taxia/views/home_screen/travel_tab.dart';

class MyTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
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
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            unselectedLabelColor: Colors.grey,
            labelColor: AppColors.textColor,
            labelStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(
                text: "My Car",
              ),
              Tab(
                text: "Home",
              ),
              Tab(
                text: "Travel",
              ),
            ],
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: TabBarView(
          children: [
            MyCarTab(),
            HomeTab(),
            TravelTab(),
          ],
        ),
      ),
    );
  }
}
