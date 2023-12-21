import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/country_select_provider.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/phone_textFiled.dart';

class PhoneValidation extends StatefulWidget {
  const PhoneValidation({super.key});

  @override
  State<PhoneValidation> createState() => _PhoneValidationState();
}

class _PhoneValidationState extends State<PhoneValidation> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        child: Consumer(
          builder: (BuildContext context, CountrySelectProvider countryProvider,
                  Widget? child) =>
              Column(
            children: [
              SizedBox(
                height: AppBar().preferredSize.height + 20,
              ),
              Text(
                'Enter Your Phone Number',
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
                  countryProvider.selectCountry(context);
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
                        countryProvider.countryCode?.name ?? "Canada",
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
                        countryProvider.countryCode?.dialCode ?? "+1",
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
              SizedBox(
                height: 5,
              ),
              PhoneTextField(
                  controller: phoneController, labelText: "Phone Number"),
              SizedBox(
                height: 25,
              ),
              CustomButton(
                  text: "OK",
                  height: 50,
                  width: screenWidth,
                  backgroundColor: AppColors.buttonColor),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
