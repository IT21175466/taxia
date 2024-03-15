import 'package:flutter/material.dart';

class CustomElement extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  CustomElement(
      {required this.label, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(imagePath),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
