import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    userProvider.checkUserTypeAndGetInfo();
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
              UserInfoCard(
                  hint: 'Full Name',
                  detail: '${userProvider.fistName} ${userProvider.lastName}'),
              UserInfoCard(hint: 'Email', detail: '${userProvider.email}'),
              UserInfoCard(
                  hint: 'Phone Number', detail: '${userProvider.phoneNumber}'),
              userProvider.isDriver
                  ? UserInfoCard(
                      hint: 'Address', detail: '${userProvider.address}')
                  : SizedBox(),
              userProvider.isDriver
                  ? UserInfoCard(
                      hint: 'BirthDay', detail: '${userProvider.birthDay}')
                  : SizedBox(),
              userProvider.isDriver
                  ? UserInfoCard(
                      hint: 'Gender', detail: '${userProvider.gender}')
                  : SizedBox(),
              userProvider.isDriver
                  ? UserInfoCard(
                      hint: 'Vehicle Brand', detail: '${userProvider.brand}')
                  : SizedBox(),
              userProvider.isDriver
                  ? UserInfoCard(
                      hint: 'Vehicle Model', detail: '${userProvider.model}')
                  : SizedBox(),
              userProvider.isDriver
                  ? UserInfoCard(
                      hint: 'Vehicle Type',
                      detail: '${userProvider.vehicleType}')
                  : SizedBox(),
              userProvider.isDriver
                  ? UserInfoCard(
                      hint: 'Vehicle Number',
                      detail: '${userProvider.vehicleNumber}')
                  : SizedBox(),
              Spacer(),
              CustomButton(
                text: 'LOGOUT',
                height: 50,
                width: screenWidth,
                backgroundColor: AppColors.accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
