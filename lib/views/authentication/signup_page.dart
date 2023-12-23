import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/custom_textFiled.dart';
import 'package:taxia/widgets/phone_textFiled.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        child: SingleChildScrollView(
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
              CustomTextField(
                  controller: phoneController, labelText: "First Name"),
              CustomTextField(
                  controller: phoneController, labelText: "Last Name"),
              CustomTextField(controller: phoneController, labelText: "Email"),
              CustomTextField(
                  controller: phoneController, labelText: "Province"),
              CustomTextField(
                  controller: phoneController, labelText: "District"),
              PhoneTextField(
                  controller: phoneController, labelText: "Phone Number"),
              // CustomTextField(
              //     controller: phoneController, labelText: "Password"),
              SizedBox(
                height: 30,
              ),
              CustomButton(
                  text: "Sign Up",
                  height: 50,
                  width: screenWidth,
                  backgroundColor: AppColors.buttonColor),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an accout?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
