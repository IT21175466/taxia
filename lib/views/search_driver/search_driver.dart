import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:taxia/constants/app_colors.dart';

class SearchDriver extends StatefulWidget {
  final LatLng pickupLocation;
  final String selectedVehicle;

  const SearchDriver({
    super.key,
    required this.pickupLocation,
    required this.selectedVehicle,
  });

  @override
  State<SearchDriver> createState() => _SearchDriverState();
}

class _SearchDriverState extends State<SearchDriver> {
  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;

    CameraPosition camaraPlexInitialPosition = CameraPosition(
      target: LatLng(
          widget.pickupLocation.latitude, widget.pickupLocation.longitude),
      zoom: 15,
    );

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: {
              Marker(
                icon: BitmapDescriptor.defaultMarker,
                markerId: MarkerId('start'),
                position: widget.pickupLocation,
                infoWindow: InfoWindow(title: 'Start Location'),
              ),
            },
            zoomControlsEnabled: false,
            // onMapCreated: (GoogleMapController mapController) {
            //   if (!googleMapCompleterController.isCompleted) {
            //     googleMapCompleterController.complete(mapController);
            //     controllerGoogleMap = mapController;
            //   }
            // },
            initialCameraPosition: camaraPlexInitialPosition,
          ),
          // Container(
          //                   height: Platform.isIOS
          //                       ? AppBar().preferredSize.height - 15
          //                       : null,
          //                 ),
          Positioned(
            left: 20,
            top: AppBar().preferredSize.height - 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 20,
            top: AppBar().preferredSize.height - 15,
            child: GestureDetector(
              onTap: () {
                //Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 246, 244, 244),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.selectedVehicle == 'car')
                              Column(
                                children: [
                                  Text("Car"),
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset('assets/images/car.png'),
                                  ),
                                ],
                              )
                            else if (widget.selectedVehicle == 'bike')
                              Column(
                                children: [
                                  Text("Bike"),
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset(
                                        'assets/images/bikeSelect.png'),
                                  ),
                                ],
                              )
                            else if (widget.selectedVehicle == 'tuk')
                              Column(
                                children: [
                                  Text("Tuk"),
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset('assets/images/tuk.png'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Searching drivers....",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: lottie.Lottie.asset(
                          'assets/animations/search_anim.json',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Platform.isIOS ? 15 : null,
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
