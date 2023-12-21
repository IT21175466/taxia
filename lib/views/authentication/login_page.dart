import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/custom_textFiled.dart';
import 'package:taxia/widgets/phone_textFiled.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height + 20,
            ),
            Text(
              'Welcome to Taxia',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            PhoneTextField(
                controller: phoneController, labelText: "Phone Number"),
            CustomTextField(
                controller: passwordController, labelText: "Password"),
            SizedBox(
              height: 25,
            ),
            CustomButton(
                text: "Log In",
                height: 50,
                width: screenWidth,
                backgroundColor: AppColors.buttonColor),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an accout?",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
