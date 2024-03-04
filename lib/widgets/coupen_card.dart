import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';

class CoupenCard extends StatelessWidget {
  final int hours;
  final int dates;
  final String endDate;
  const CoupenCard(
      {super.key,
      required this.hours,
      required this.dates,
      required this.endDate});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            "T",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: AppColors.accentColor,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          // Divider(
          //   height: 2,
          //   color: Colors.grey,
          //   thickness: 2.5,
          // ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Taxia",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.accentColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    hours.toString(),
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Hours",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'x',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    dates.toString(),
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Coupons",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Text(
                "Valid until ${endDate}",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
