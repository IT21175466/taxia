import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final String hintText;

  const PhoneTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 50,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText, //"71XXXXXXX"
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: AppColors.grayColor,
              width: 0.5,
            ),
          ),
          labelText: labelText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        ),
      ),
    );
  }
}
