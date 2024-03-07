import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/user/user_provider.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/user_info_card.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.getUserAccountInfo();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Info",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.accentColor,
      ),
      body: Consumer(
        builder:
            (BuildContext context, UserProvider userProvider, Widget? child) =>
                Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              Divider(),
              Row(
                children: [
                  Text(
                    'Points',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(),
                  Text(
                    userProvider.points!.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 25,
                    child: Image.asset('assets/images/points.png'),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: 15,
              ),
              UserInfoCard(
                  hint: 'Full Name',
                  detail: '${userProvider.fistName} ${userProvider.lastName}'),
              UserInfoCard(hint: 'Email', detail: '${userProvider.email}'),
              UserInfoCard(
                  hint: 'Phone Number', detail: '${userProvider.phoneNumber}'),
              UserInfoCard(
                  hint: 'District', detail: '${userProvider.district}'),
              UserInfoCard(
                  hint: 'Province', detail: '${userProvider.province}'),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('logedIn', false);

                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
                child: CustomButton(
                  text: 'LOGOUT',
                  height: 50,
                  width: screenWidth,
                  backgroundColor: AppColors.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
