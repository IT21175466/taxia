import 'package:flutter/material.dart';

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
            Container(
              child: Center(
                child: Text("My Car"),
              ),
            ),
            Container(
              child: Center(
                child: Text("Home"),
              ),
            ),
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
