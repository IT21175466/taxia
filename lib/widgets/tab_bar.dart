import 'package:flutter/material.dart';
import 'package:taxia/views/home_screen/home_tab.dart';
import 'package:taxia/views/home_screen/my_car_tab.dart';

class MyTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 18,
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
            Container(
              child: Center(
                child: Text("Travel"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
