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
            height: 30,
            width: 30,
            child: Image.asset(imagePath),
          ),
          SizedBox(
            height: 5,
          ),
          Text(label),
        ],
      ),
    );
  }
}
