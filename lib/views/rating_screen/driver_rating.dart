import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/ride/ride_provider.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:taxia/widgets/custom_textFiled.dart';

class DriverRating extends StatefulWidget {
  final String passengerID;
  final String rideID;
  final String firstName;
  //final String phoneNumber;
  final String progileImage;
  const DriverRating({
    super.key,
    required this.passengerID,
    required this.rideID,
    required this.firstName,
    //required this.phoneNumber,
    required this.progileImage,
  });

  @override
  State<DriverRating> createState() => _DriverRatingState();
}

class _DriverRatingState extends State<DriverRating> {
  final TextEditingController reviewCommentController = TextEditingController();
  double starRating = 0.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Rating",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.accentColor,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Consumer(
          builder: (BuildContext context, RideProvider rideProvider,
              Widget? child) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Row(
                    children: [
                      Text(
                        widget.firstName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Spacer(),
                      // Text(
                      //   widget.phoneNumber,
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: 15,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'How was your trip?',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Give your valuble feedback to driver',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      setState(() {
                        starRating = rating;
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                      controller: reviewCommentController,
                      labelText: 'Write a Review'),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await rideProvider.updateReviewToUser(
                        widget.passengerID,
                        widget.rideID,
                        starRating,
                        reviewCommentController.text,
                      );
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/driverhome', (route) => false);
                    },
                    child: CustomButton(
                      text: 'Done',
                      height: 50,
                      width: screenWidth,
                      backgroundColor: AppColors.accentColor,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
