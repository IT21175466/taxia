import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/global/global.dart';
import 'package:taxia/providers/user/login_provider.dart';
import 'package:taxia/views/driver/accept_ride/accept_ride.dart';
import 'package:taxia/widgets/custom_button.dart';

class GetRequestsMap extends StatefulWidget {
  const GetRequestsMap({super.key});

  @override
  State<GetRequestsMap> createState() => _GetRequestsMapState();
}

class _GetRequestsMapState extends State<GetRequestsMap> {
  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  Position? driverLocation;

  bool isLoading = true;
  bool isOnline = false;

  double distance = 0.00;

  Set<Marker> markers = Set<Marker>();

  GoogleMapController? controllerGoogleMap;

  late Uint8List customMarkerIcon;

  LoginProvider? loginProvider;

  @override
  void initState() {
    super.initState();
    gerCurrentLiveLocationOfUser();
    loadCustomMaker();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  void _startListening() {
    databaseReference.onValue.listen((event) {
      getPickupData();
    });
  }

  gerCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    setState(() {
      driverLocation = positionOfUser;

      LatLng positionOfUserInLatLng =
          LatLng(driverLocation!.latitude, driverLocation!.longitude);

      CameraPosition cameraPosition =
          CameraPosition(target: positionOfUserInLatLng, zoom: 12);

      controllerGoogleMap!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      isLoading = false;
    });
  }

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('rides');

  //Get user pickup request distance
  void getPickupData() {
    markers.clear();
    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map?;

      if (values != null) {
        values.forEach((key, rideData) {
          print('Key: $key');

          if (rideData is Map &&
              rideData.containsKey('picupLocationLat') &&
              rideData.containsKey('picupLocationLong') &&
              rideData.containsKey('vehicleType')) {
            // print('picupLocationLat: ${rideData['picupLocationLat']}');
            // print('picupLocationLong: ${rideData['picupLocationLong']}');

            getDistance(
                driverLocation!.latitude,
                driverLocation!.longitude,
                rideData['picupLocationLat'],
                rideData['picupLocationLong'],
                rideData['vehicleType'],
                rideData['dropLocationLat'],
                rideData['dropLocationLong'],
                rideData['vehicleType'],
                rideData['totalPrice'],
                rideData['totalKm'],
                rideData['rideID'],
                rideData['pID']);
          } else {
            print('Invalid data structure or missing values for key $key');
          }
        });
      } else {
        print('No data found under "rides" node.');
      }
    });
  }

  Future<void> getDistance(
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    String requiredVehicleType,
    double? dropLoationLat,
    double? dropLoationLon,
    String? selectedVehicle,
    double? totalPrice,
    double? totalKM,
    String? rideID,
    String? passengerID,
  ) async {
    String Url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${startLatitude},${startLongitude}&origins=${endLatitude},${endLongitude}&key=AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY';

    try {
      var response = await http.get(
        Uri.parse(Url),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        String distanceText =
            data['rows'][0]['elements'][0]['distance']['text'];

        String durationText =
            data['rows'][0]['elements'][0]['duration']['text'];

        setState(() {
          distance = double.parse(distanceText.split(' ')[0].toString());
        });
        print(response.body);
        //print(loginProvider!.vehicleType);

        if (distance < 10.0) {
          if (requiredVehicleType == loginProvider!.vehicleType) {
            //Match Vehicle Type
            await markers.add(
              Marker(
                icon: BitmapDescriptor.fromBytes(
                  customMarkerIcon,
                ),
                markerId: MarkerId('$endLatitude'),
                position: LatLng(endLatitude!, endLongitude!),
                //infoWindow: customInfoWindow(context, distance),
                onTap: () {
                  customInfoWindowController.addInfoWindow!(
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.accentColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "In $distance KM",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Text(
                                durationText,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              //remove marker

                              //accept the ride request
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AcceptRide(
                                    rideID: rideID!,
                                    passengerID: passengerID!,
                                    pickupLatLon:
                                        LatLng(startLatitude!, startLongitude!),
                                    driverLatLon:
                                        LatLng(endLatitude, endLongitude),
                                    distance: distance,
                                    timeDuration: durationText,
                                    dropLoationLat: dropLoationLat!,
                                    dropLoationLon: dropLoationLon!,
                                    selectedVehicle: selectedVehicle!,
                                    totalPrice: totalPrice!,
                                    totalKM: totalKM!,
                                  ),
                                ),
                              );
                            },
                            child: CustomButton(
                              text: 'More',
                              height: 40,
                              width: 200,
                              backgroundColor: AppColors.buttonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LatLng(endLatitude, endLongitude),
                  );
                },
              ),
            );
          } else {
            print("Vehicle type not matched!");
          }
        } else {
          print("no");
        }

        return jsonDecode(response.body);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void toggleOnlineOffline() {
    setState(() {
      isOnline = !isOnline;
      if (isOnline) {
        _startListening();
      } else {
        Navigator.pushReplacementNamed(context, ("/drivermap"));
      }
    });
  }

  loadCustomMaker() async {
    customMarkerIcon = await loadAsset('assets/images/man.png', 250);
  }

  double radians(double degrees) {
    return degrees * (pi / 180.0);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String buttonText = isOnline ? 'Go Offline' : 'Go Online';

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: false,
            markers: markers,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController mapController) {
              if (!googleMapCompleterController.isCompleted) {
                googleMapCompleterController.complete(mapController);
                controllerGoogleMap = mapController;
                customInfoWindowController.googleMapController = mapController;
              }
            },
            initialCameraPosition: googlePlexInitialPosition,
            onTap: (argument) {
              customInfoWindowController.hideInfoWindow!();
            },
          ),
          CustomInfoWindow(
            height: 100,
            width: 200,
            offset: 35,
            controller: customInfoWindowController,
          ),
          isLoading
              ? Positioned(
                  top: screenHeight / 3,
                  left: 30,
                  right: 30,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Loading your location...."),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          Positioned(
            left: 30,
            right: 30,
            top: AppBar().preferredSize.height - 15,
            child: GestureDetector(
              onTap: () {
                toggleOnlineOffline();
              },
              child: CustomButton(
                text: buttonText,
                height: 50,
                width: 150,
                backgroundColor: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
