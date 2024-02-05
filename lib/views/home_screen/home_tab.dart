import 'package:flutter/material.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/widgets/custom_element.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 14, 88, 216),
                      width: 1,
                    ),
                  ),
                  labelText: "Where should I go?",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayColor,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Leave"),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "now",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down_outlined),
                      ],
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Icon(Icons.home_outlined),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Home",
                  style: TextStyle(),
                ),
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.work_outline),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Work",
                  style: TextStyle(),
                ),
              ],
            ),
            // Container(
            //   width: screenWidth,
            //   height: 120,
            //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   margin: EdgeInsets.only(top: 10),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //     color: Colors.blueAccent.withOpacity(0.2),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Text(
            //             "Ongoing Ride...",
            //             style: TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.w700,
            //             ),
            //           ),
            //           Spacer(),
            //           Text(
            //             "See More",
            //             style: TextStyle(
            //               fontSize: 15,
            //               fontWeight: FontWeight.w500,
            //               color: Colors.blue,
            //             ),
            //           ),
            //         ],
            //       ),
            //       Text(
            //         "Register in 1 minute!",
            //         style: TextStyle(
            //           fontSize: 15,
            //           fontWeight: FontWeight.w400,
            //           color: AppColors.grayColor,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            SizedBox(
              height: 25,
            ),
            Row(
              //Tempory
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Taxi",
                      imagePath: 'assets/images/taxi.png',
                      onTap: () {
                        Navigator.pushNamed(context, '/map');
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElement(
                      label: "Show All",
                      imagePath: 'assets/images/dots.png',
                      onTap: () {},
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Pet",
                    //   imagePath: 'assets/images/pet.png',
                    //   onTap: () {},
                    // ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Book Taxi",
                      imagePath: 'assets/images/bookTaxi.png',
                      onTap: () {},
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Rent Car",
                    //   imagePath: 'assets/images/rentCar.png',
                    //   onTap: () {},
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Train",
                    //   imagePath: 'assets/images/train.png',
                    //   onTap: () {},
                    // ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElement(
                      label: "Bike",
                      imagePath: 'assets/images/bike.png',
                      onTap: () {},
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Flight",
                    //   imagePath: 'assets/images/airplane.png',
                    //   onTap: () {},
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "Charter bus",
                    //   imagePath: 'assets/images/charter.png',
                    //   onTap: () {},
                    // ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CustomElement(
                    //   label: "Parking",
                    //   imagePath: 'assets/images/parking.png',
                    //   onTap: () {},
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomElement(
                    //   label: "EV Charge",
                    //   imagePath: 'assets/images/charging.png',
                    //   onTap: () {},
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),

                    CustomElement(
                      label: "Quick",
                      imagePath: 'assets/images/delivery.png',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'This feature not available at this moment'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                //Spacer(),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     CustomElement(
                //       label: "Driver",
                //       imagePath: 'assets/images/driverElement.png',
                //       onTap: () {},
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     CustomElement(
                //       label: "Request",
                //       imagePath: 'assets/images/request.png',
                //       onTap: () {},
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     CustomElement(
                //       label: "Request",
                //       imagePath: 'assets/images/request.png',
                //       onTap: () {},
                //     ),
                //   ],
                // ),
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
