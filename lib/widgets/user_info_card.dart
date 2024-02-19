import 'package:flutter/material.dart';

class UserInfoCard extends StatefulWidget {
  final String hint;
  final String detail;
  const UserInfoCard({super.key, required this.hint, required this.detail});

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: screenWidth,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 229, 229, 229),
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(
        //   color: Colors.grey,
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hint,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            widget.detail,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
