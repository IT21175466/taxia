import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/user/user_provider.dart';
import 'package:taxia/widgets/history_ride_card.dart';

class DriverRideHistory extends StatefulWidget {
  const DriverRideHistory({super.key});

  @override
  State<DriverRideHistory> createState() => _DriverRideHistoryState();
}

class _DriverRideHistoryState extends State<DriverRideHistory> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ride History",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.accentColor,
      ),
      body: Consumer(
        builder:
            (BuildContext context, UserProvider userProvider, Widget? child) =>
                Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
          ),
          color: const Color.fromARGB(255, 213, 213, 213),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Rides')
                .doc(userProvider.userID)
                .collection("Users")
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
                  child: Text(
                    'Loading.....',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                var docs = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return HistoryRideCard(
                        vehicleType: docs[index]['vehicleType'],
                        dateAndTime: docs[index]['trip_Date'],
                        pickupLocation: docs[index]['pickAddress'],
                        dropLocation: docs[index]['dropAddress'],
                        totalPrice:
                            double.parse(docs[index]['totalPrice'].toString()),
                        totalKM: double.parse(
                          docs[index]['totalKMs'].toString(),
                        ),
                      );
                      // QuizHistoryCard(
                      //   title: docs[index]['QuizName'],
                      //   marks: docs[index]['Marks'],
                      //   didDate: docs[index]['Date'],
                      //   id: docs[index]['StudentID'],
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
      ),
    );
  }
}
