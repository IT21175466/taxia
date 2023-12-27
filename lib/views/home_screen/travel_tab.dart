import 'package:flutter/material.dart';
import 'package:taxia/widgets/custom_element.dart';

class TravelTab extends StatefulWidget {
  const TravelTab({super.key});

  @override
  State<TravelTab> createState() => _TravelTabState();
}

class _TravelTabState extends State<TravelTab> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Overseas",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                CustomElement(
                  label: "International",
                  imagePath: 'assets/images/plane.png',
                  onTap: () {},
                ),
                Spacer(),
                CustomElement(
                  label: "Request",
                  imagePath: 'assets/images/request.png',
                  onTap: () {},
                ),
                Spacer(),
                CustomElement(
                  label: "Guam Taxi",
                  imagePath: 'assets/images/gaumTaxi.png',
                  onTap: () {},
                ),
                Spacer(),
                CustomElement(
                  label: "Guam Tour",
                  imagePath: 'assets/images/gaumTour.png',
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Domestic",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Domestic",
                      imagePath: 'assets/images/plane.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Citytour",
                      imagePath: 'assets/images/cityTour.png',
                      onTap: () {},
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Leisure",
                      imagePath: 'assets/images/airBalloon.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Bus",
                      imagePath: 'assets/images/bus.png',
                      onTap: () {},
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Tshuttle",
                      imagePath: 'assets/images/shuttle.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Train",
                      imagePath: 'assets/images/train.png',
                      onTap: () {},
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Tshuttle",
                      imagePath: 'assets/images/shuttle.png',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Rent Car",
                      imagePath: 'assets/images/rentCar.png',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
