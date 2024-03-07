import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/auth/phone_number_provider.dart';
import 'package:taxia/widgets/custom_button.dart';
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
        child: Consumer(
          builder: (BuildContext context,
                  PhoneNumberProvider phoneNumberProvider, Widget? child) =>
              Column(
            children: [
              SizedBox(
                height: AppBar().preferredSize.height + 20,
              ),
              Text(
                'Welcome to Flego Taxi',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  phoneNumberProvider.selectCountry(context);
                },
                child: Container(
                  width: screenWidth,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: AppColors.grayColor,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        phoneNumberProvider.countryCode?.name ?? "Canada",
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
                        phoneNumberProvider.countryCode?.dialCode ?? "+1",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              PhoneTextField(
                controller: phoneController,
                labelText: "Phone Number",
                hintText: '71XXXXXXX',
              ),
              // CustomTextField(
              //     controller: passwordController, labelText: "Password"),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  if (phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter your Phone Number"),
                      ),
                    );
                  } else {
                    phoneNumberProvider.loading = true;
                    phoneNumberProvider.verifyPhoneNumber(
                        phoneController.text, context);
                  }
                },
                child: phoneNumberProvider.loading
                    ? Container(
                        height: 50,
                        width: screenWidth,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : CustomButton(
                        text: "Continue",
                        height: 50,
                        width: screenWidth,
                        backgroundColor: AppColors.buttonColor),
              ),

              SizedBox(
                height: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Don't have an accout?",
              //       style: TextStyle(
              //         fontSize: 15,
              //         fontWeight: FontWeight.w400,
              //         color: AppColors.textColor,
              //       ),
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.pushNamed(context, '/phonevalidation');
              //       },
              //       child: Text(
              //         "Sign Up",
              //         style: TextStyle(
              //           fontSize: 15,
              //           fontWeight: FontWeight.w400,
              //           color: Colors.blueAccent,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
