import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/providers/user/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(
              text: "Home",
            ),
            Tab(
              text: "My Car",
            ),
            Tab(
              text: "Travel",
            ),
          ]),
          title: Text("Home" + id!),
          leading: GestureDetector(
            onTap: () async {
              await userProvider.logOutUser();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Icon(Icons.logout),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Center(
                child: Text("Home"),
              ),
            ),
            Container(
              child: Center(
                child: Text("My Car"),
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
