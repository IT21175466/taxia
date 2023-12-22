import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/user_type_provider.dart';

class UserTypeSelection extends StatefulWidget {
  const UserTypeSelection({super.key});

  @override
  State<UserTypeSelection> createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your Role',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        child: Consumer(
          builder: (BuildContext context, UserTypeProvider userTypeProvider,
                  Widget? child) =>
              Column(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () {
                  userTypeProvider.isDriver = true;
                  userTypeProvider.isPassenger = false;
                  userTypeProvider.changeUserType();
                },
                child: Container(
                  height: 250,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: userTypeProvider.isDriver
                          ? Colors.blueAccent
                          : AppColors.accentColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Image.asset('assets/images/driver.png'),
                        ),
                      ),
                      Text(
                        'Driver',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        'Join as a Driver',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () async {
                  userTypeProvider.isPassenger = true;
                  userTypeProvider.isDriver = false;
                  userTypeProvider.changeUserType();
                },
                child: Container(
                  height: 250,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: userTypeProvider.isPassenger
                          ? Colors.blueAccent
                          : AppColors.accentColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Image.asset('assets/images/passenger.png'),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Passenger',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        'Join as a Passenger',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
