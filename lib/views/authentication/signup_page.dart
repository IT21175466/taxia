import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/models/user.dart';
import 'package:taxia/providers/auth/otp_provider.dart';
import 'package:taxia/providers/user/user_provider.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/custom_textFiled.dart';
import 'package:taxia/widgets/user_role_dropdown.dart';

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
  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OTPProvider>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        child: SingleChildScrollView(
          child: Consumer(
            builder: (BuildContext context, UserProvider userProvider,
                    Widget? child) =>
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
                UserRoleDropdown(
                  selectedRole: userProvider.selectedRole,
                  onChanged: (value) {
                    userProvider.selectedRole = value!;
                  },
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
                        districtController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter all required details!"),
                        ),
                      );
                    } else if (userProvider.selectedRole ==
                        "Select Your Role") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select your Role!"),
                        ),
                      );
                    } else {
                      // userProvider.userID =
                      //     userProvider.generateRandomId().toString();
                      userProvider.loading = true;

                      final addUser = User(
                          userID: otpProvider.userId,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          province: provinceController.text,
                          district: districtController.text);

                      userProvider.addUserToFirebase(
                          addUser, context, otpProvider.userId);
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
