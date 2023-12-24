import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/user/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    Center(
      child: Text("Home"),
    ),
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
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        // TabBarView(
        //   children: [
        //     Container(
        //       child: Center(
        //         child: Text("Home"),
        //       ),
        //     ),
        //     Container(
        //       child: Center(
        //         child: Text("My Car"),
        //       ),
        //     ),
        //     Container(
        //       child: Center(
        //         child: Text("Travel"),
        //       ),
        //     ),
        //   ],
        // ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: AppColors.iconColor,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.badge_outlined,
                color: AppColors.iconColor,
              ),
              label: "Business",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: AppColors.iconColor,
              ),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_outlined,
                color: AppColors.iconColor,
              ),
              label: "My Info",
            ),
          ],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
              color: AppColors.textColor, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(
            color: AppColors.textColor,
          ),
        ),
      ),
    );
  }
}
