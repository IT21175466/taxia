import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';

class UserRoleDropdown extends StatelessWidget {
  final String selectedRole;
  final void Function(String?) onChanged;

  const UserRoleDropdown({
    Key? key,
    required this.selectedRole,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: DropdownButtonFormField<String>(
          value: selectedRole,
          onChanged: onChanged,
          items: <String>[
            "Select Your Role",
            "User",
            "Driver",
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            isDense: true,
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
          ),
        ),
      ),
    );
  }
}
