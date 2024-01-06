import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxia/constants/app_colors.dart';

class RideAccepted extends StatefulWidget {
  final String rideID;
  final String userID;
  final LatLng pickupLocation;
  const RideAccepted(
      {super.key,
      required this.rideID,
      required this.userID,
      required this.pickupLocation});

  @override
  State<RideAccepted> createState() => _RideAcceptedState();
}

class _RideAcceptedState extends State<RideAccepted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height - 15,
                left: 15,
                right: 15,
                bottom: 15,
              ),
              color: Color.fromARGB(255, 39, 38, 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.home),
                      Spacer(),
                      Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.grayColor,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.call),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.grayColor,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.man),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.grayColor,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.message),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Chamath",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.grayColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 232, 22),
                    ),
                    child: const Text(
                      "Emergency - 1334",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
