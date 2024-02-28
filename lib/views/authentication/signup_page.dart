import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/models/user.dart';
import 'package:taxia/providers/auth/phone_number_provider.dart';
import 'package:taxia/providers/user/user_provider.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/custom_textFiled.dart';
import 'package:taxia/widgets/phone_textFiled.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? userID = '';

  getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
    });
  }

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        child: SingleChildScrollView(
          child: Consumer2(
            builder: (BuildContext context, UserProvider userProvider,
                    PhoneNumberProvider phoneNumberProvider, Widget? child) =>
                Column(
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
                    controller: firstNameController, labelText: "First Name"),
                CustomTextField(
                    controller: lastNameController, labelText: "Last Name"),

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
                          phoneNumberProvider.countryCode?.name ??
                              "Select Country",
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
                          phoneNumberProvider.countryCode?.dialCode ?? "",
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

                CustomTextField(
                    controller: emailController, labelText: "Email"),
                CustomTextField(
                    controller: provinceController, labelText: "Province"),
                CustomTextField(
                    controller: districtController, labelText: "District"),
                // PhoneTextField(
                //     controller: phoneController, labelText: "Phone Number"),
                // CustomTextField(
                //     controller: phoneController, labelText: "Password"),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    if (firstNameController.text.isEmpty ||
                        lastNameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        provinceController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        districtController.text.isEmpty ||
                        phoneNumberProvider.countryCode?.name == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Please enter all required details correctly!",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    } else {
                      // userProvider.userID =
                      //     userProvider.generateRandomId().toString();

                      String phoneNo =
                          "${phoneNumberProvider.countryCode?.dialCode}" +
                              phoneController.text;
                      userProvider.loading = true;

                      final addUser = User(
                        userID: userID!,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        email: emailController.text,
                        province: provinceController.text,
                        district: districtController.text,
                        phoneNum: phoneNo,
                        date: DateTime.now(),
                        points: 0,
                      );

                      userProvider.addUserToFirebase(addUser, context, userID!);
                    }
                  },
                  child: userProvider.loading
                      ? Container(
                          height: 50,
                          width: screenWidth,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : CustomButton(
                          text: "Sign Up",
                          height: 50,
                          width: screenWidth,
                          backgroundColor: AppColors.buttonColor),
                ),
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
      ),
    );
  }
}
