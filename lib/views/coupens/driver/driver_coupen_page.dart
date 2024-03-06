import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/user/user_provider.dart';
import 'package:taxia/widgets/coupen_card.dart';

class DriverCoupenPage extends StatefulWidget {
  final String driverId;
  const DriverCoupenPage({super.key, required this.driverId});

  @override
  State<DriverCoupenPage> createState() => _DriverCoupenPageState();
}

class _DriverCoupenPageState extends State<DriverCoupenPage> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.totalCouponHours = 0;
    userProvider.progress = 0.0;
    userProvider.availableTime = 0;
    userProvider.getDriverCoupens();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Coupens",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.accentColor,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        color: const Color.fromARGB(255, 213, 213, 213),
        child: Consumer(
          builder: (BuildContext context, UserProvider userProvider,
                  Widget? child) =>
              Column(
            children: [
              LinearPercentIndicator(
                width: screenWidth - 50,
                lineHeight: 20.0,
                percent:
                    userProvider.progress < 0.0 ? 0.0 : userProvider.progress,
                center: Text(
                  "Ends in ${userProvider.availableTime ~/ 24} days and ${userProvider.availableTime % 24} hours",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: Colors.grey,
                progressColor: Colors.blue,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Coupons')
                      .doc(widget.driverId)
                      .collection('coupon')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Connection Error!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      Center(
                        child: CircularProgressIndicator.adaptive(),
                        // Text(
                        //   'Loading.....',
                        //   style: TextStyle(
                        //     fontFamily: 'Poppins',
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: 16,
                        //   ),
                        // ),
                      );
                    }
                    if (snapshot.hasData) {
                      var docs = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            //setState(() {
                            // couponProvider.difference =
                            //     couponProvider.difference +
                            //         int.parse(
                            //             DateTime.parse(docs[index]['couponEndOn'])
                            //                 .difference(DateTime.now())
                            //                 .inHours
                            //                 .toString());

                            // print(couponProvider.difference);

                            // couponProvider.availableTotalHours = couponProvider
                            //         .availableTotalHours +
                            //     int.parse(docs[index]['couponTime'].toString()) *
                            //         int.parse(
                            //             docs[index]['couponAmount'].toString());

                            // print(couponProvider.availableTotalHours);
                            //});

                            return CoupenCard(
                              hours: int.parse(
                                  docs[index]['couponTime'].toString()),
                              dates: int.parse(
                                  docs[index]['couponAmount'].toString()),
                              endDate: DateFormat('d MMM y')
                                  .format(DateTime.parse(
                                      docs[index]['couponEndOn']))
                                  .toString(),
                            );
                            // HistoryRideCard(
                            //   vehicleType: docs[index]['vehicleType'],
                            //   dateAndTime: docs[index]['trip_Date'],
                            //   pickupLocation: docs[index]['pickAddress'],
                            //   dropLocation: docs[index]['dropAddress'],
                            //   totalPrice:
                            //       double.parse(docs[index]['totalPrice'].toString()),
                            //   totalKM: double.parse(
                            //     docs[index]['totalKMs'].toString(),
                            //   ),
                            //   ratingStars:
                            //       double.parse(docs[index]['rating_Starts'].toString()),
                            // );
                          });
                    }
                    return Center(
                      child: Text(
                        'No Docs',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
