import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/otp_provider.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/phone_textFiled.dart';

class OTPVerifyPage extends StatefulWidget {
  final String verificationID;
  OTPVerifyPage({super.key, required this.verificationID});

  @override
  State<OTPVerifyPage> createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> {
  final TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        child: Consumer(
          builder:
              (BuildContext context, OTPProvider otpProvider, Widget? child) =>
                  Column(
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
              PhoneTextField(controller: otpController, labelText: "OTP"),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  if (otpController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter OTP"),
                      ),
                    );
                  } else {
                    otpProvider.loading = true;
                    otpProvider.getOTPCode(
                        widget.verificationID, otpController.text, context);
                  }
                },
                child: otpProvider.loading
                    ? Container(
                        height: 55,
                        width: screenWidth,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : CustomButton(
                        text: "OK",
                        height: 50,
                        width: screenWidth,
                        backgroundColor: AppColors.accentColor),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Edit Phone Number',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
