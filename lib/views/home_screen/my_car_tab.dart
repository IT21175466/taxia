import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/widgets/custom_element.dart';

class MyCarTab extends StatefulWidget {
  const MyCarTab({super.key});

  @override
  State<MyCarTab> createState() => _MyCarTabState();
}

class _MyCarTabState extends State<MyCarTab> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: 120,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueAccent.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Register My Car",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.add,
                        color: AppColors.grayColor,
                      ),
                    ],
                  ),
                  Text(
                    "Register in 1 minute!",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grayColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset('assets/images/star.png'),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Refill",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grayColor,
                  ),
                ),
                Spacer(),
                Text(
                  "Refill",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                VerticalDivider(
                  color: Colors.amber,
                ),
                Text(
                  "Gift",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                VerticalDivider(
                  color: Colors.amber,
                ),
                Container(
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          "event",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: Image.asset('assets/images/celebrate.png'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Navi",
                      imagePath: 'assets/images/navigation.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Valet",
                      imagePath: 'assets/images/valet.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "EVsubsidy",
                      imagePath: 'assets/images/evSubsidy.png',
                      onTap: () {},
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Parking",
                      imagePath: 'assets/images/parking.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Checkup",
                      imagePath: 'assets/images/checkup.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Insurance",
                      imagePath: 'assets/images/insurance.png',
                      onTap: () {},
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Car Wash",
                      imagePath: 'assets/images/carWash.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Sell My Car",
                      imagePath: 'assets/images/sellCar.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Buy T4K",
                      imagePath: 'assets/images/electricTruck.png',
                      onTap: () {},
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Driver",
                      imagePath: 'assets/images/driverElement.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "EV Charge",
                      imagePath: 'assets/images/charging.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Repair",
                      imagePath: 'assets/images/repair.png',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
