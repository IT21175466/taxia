import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/phone_textFiled.dart';

class OTPVerifyPage extends StatefulWidget {
  const OTPVerifyPage({super.key});

  @override
  State<OTPVerifyPage> createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> {
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppBar().preferredSize.height + 30,
            ),
            Text(
              'Mobile Phone Number Verification',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            Text(
              'Please enter the OTP code sent to your phone number.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.grayColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            PhoneTextField(controller: phoneController, labelText: "OTP"),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                text: "OK",
                height: 50,
                width: screenWidth,
                backgroundColor: AppColors.accentColor),
          ],
        ),
      ),
    );
  }
}
