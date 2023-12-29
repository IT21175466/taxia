import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/global/global.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Uint8List customMarkerIcon;

  bool isSelectedLocation = false;

  bool isCar = true;
  bool isTuk = false;
  bool isBike = false;

  String distance = 'Calculating...';

  double carCharge = 0.0;
  double bikeCharge = 0.0;
  double tukCharge = 0.0;

  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  LatLng? pickupLocation;
  LatLng? endLocation;

  Future<void> getDistance(
      {double? startLatitude,
      double? startLongitude,
      double? endLatitude,
      double? endLongitude}) async {
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

        setState(() {
          distance = distanceText;
        });

        return jsonDecode(response.body);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<LatLng> polylineCordinates = [];

  //Position? currentPositionOfUser;

  Set<Marker> markers = Set<Marker>();

  GoogleMapController? controllerGoogleMap;

  final TextEditingController pickupLocationController =
      TextEditingController();
  final TextEditingController endLocationController = TextEditingController();

  @override
  void initState() {
    loadCustomMaker();
    getData();
    super.initState();
  }

  loadCustomMaker() async {
    customMarkerIcon = await loadAsset('assets/images/man.png', 100);
  }

  double radians(double degrees) {
    return degrees * (pi / 180.0);
  }

  void getData() async {
    final DocumentSnapshot ratesDoc = await FirebaseFirestore.instance
        .collection("Admin")
        .doc('prices')
        .get();

    setState(() {
      carCharge = double.parse(ratesDoc.get('perBike').toString());
      bikeCharge = double.parse(ratesDoc.get('perCar').toString());
      tukCharge = double.parse(ratesDoc.get('perTuk').toString());
    });
  }

  calculateCharges() {
    setState(() {
      carCharge = carCharge * double.parse(distance.split(' ')[0].toString());
      bikeCharge = bikeCharge * double.parse(distance.split(' ')[0].toString());
      tukCharge = tukCharge * double.parse(distance.split(' ')[0].toString());
    });
  }

  showValues() async {
    await getDistance(
      startLatitude: pickupLocation!.latitude,
      startLongitude: pickupLocation!.longitude,
      endLatitude: endLocation!.latitude,
      endLongitude: endLocation!.longitude,
    );

    calculateCharges();
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

  void drowPolyline(String placeID) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
      PointLatLng(pickupLocation!.latitude, pickupLocation!.longitude),
      PointLatLng(endLocation!.latitude, endLocation!.longitude),
    );

    setState(() {
      polylineCordinates.clear();

      polylineResult.points.forEach(
        (PointLatLng points) => polylineCordinates.add(
          LatLng(points.latitude, points.longitude),
        ),
      );
    });
  }

  // gerCurrentLiveLocationOfUser() async {
  //   Position positionOfUser = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);

  //   currentPositionOfUser = positionOfUser;

  //   LatLng positionOfUserInLatLng = LatLng(
  //       currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

  //   CameraPosition cameraPosition =
  //       CameraPosition(target: positionOfUserInLatLng, zoom: 45);

  //   controllerGoogleMap!
  //       .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //   notifyListeners();
  // }

  void focusCameraOnPickupAndEndLocations() {
    if (pickupLocation != null && endLocation != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          pickupLocation!.latitude < endLocation!.latitude
              ? pickupLocation!.latitude
              : endLocation!.latitude,
          pickupLocation!.longitude < endLocation!.longitude
              ? pickupLocation!.longitude
              : endLocation!.longitude,
        ),
        northeast: LatLng(
          pickupLocation!.latitude > endLocation!.latitude
              ? pickupLocation!.latitude
              : endLocation!.latitude,
          pickupLocation!.longitude > endLocation!.longitude
              ? pickupLocation!.longitude
              : endLocation!.longitude,
        ),
      );

      setState(() {
        controllerGoogleMap!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50.0),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            zoomControlsEnabled: false,
            polylines: {
              Polyline(
                polylineId: PolylineId("route"),
                points: polylineCordinates,
                visible: true,
                width: 5,
                color: Colors.blue,
              ),
            },
            onMapCreated: (GoogleMapController mapController) {
              if (!googleMapCompleterController.isCompleted) {
                googleMapCompleterController.complete(mapController);
                controllerGoogleMap = mapController;
              }

              // mapProvider.controllerGoogleMap = mapController;

              // mapProvider.googleMapCompleterController
              //     .complete(mapProvider.controllerGoogleMap);
            },
            initialCameraPosition: googlePlexInitialPosition,
          ),
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: Container(
              child: isSelectedLocation
                  ? Column(
                      children: [
                        Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                "Pickup - ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(pickupLocationController.text),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSelectedLocation = false;
                                  });
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Drop - ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(endLocationController.text),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSelectedLocation = false;
                                  });
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        GooglePlaceAutoCompleteTextField(
                          boxDecoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                          ),
                          textEditingController: pickupLocationController,
                          googleAPIKey:
                              "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
                          inputDecoration: InputDecoration(
                            hintText: "Pickup Location",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                          ),
                          debounceTime: 800,
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (Prediction prediction) {
                            pickupLocation = LatLng(
                              double.parse(prediction.lat.toString()),
                              double.parse(prediction.lng.toString()),
                            );

                            markers.add(
                              Marker(
                                icon: BitmapDescriptor.fromBytes(
                                    customMarkerIcon),
                                markerId: MarkerId('start'),
                                position: pickupLocation!,
                                infoWindow: InfoWindow(title: 'Start Location'),
                              ),
                            );

                            // CameraPosition cameraPosition =
                            //     CameraPosition(target: pickupLocation!, zoom: 15);

                            // controllerGoogleMap!.animateCamera(
                            //     CameraUpdate.newCameraPosition(cameraPosition));
                            //print(pickupLocation);
                          },
                          itemClick: (Prediction prediction) {
                            pickupLocationController.text =
                                prediction.description!;
                            pickupLocationController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: prediction.description!.length),
                            );
                          },
                          itemBuilder: (context, index, Prediction prediction) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Expanded(
                                    child:
                                        Text("${prediction.description ?? ""}"),
                                  ),
                                ],
                              ),
                            );
                          },
                          isCrossBtnShown: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GooglePlaceAutoCompleteTextField(
                          boxDecoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                          ),
                          textEditingController: endLocationController,
                          googleAPIKey:
                              "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
                          inputDecoration: InputDecoration(
                            hintText: "End Location",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                          ),
                          debounceTime: 800,
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (Prediction prediction) {
                            endLocation = LatLng(
                              double.parse(prediction.lat.toString()),
                              double.parse(prediction.lng.toString()),
                            );

                            // if (mapProvider.markers.length >= 2) {
                            //   mapProvider.markers.remove(mapProvider.markers.last);
                            // }

                            markers.add(
                              Marker(
                                icon: BitmapDescriptor.defaultMarker,
                                markerId: MarkerId('end'),
                                position: endLocation!,
                                infoWindow: InfoWindow(title: 'End Location'),
                              ),
                            );

                            // Call the drawPolyline method
                            drowPolyline('start-end');

                            focusCameraOnPickupAndEndLocations();
                            setState(() {
                              isSelectedLocation = true;
                            });

                            showValues();
                          },
                          itemClick: (Prediction prediction) {
                            endLocationController.text =
                                prediction.description!;
                            endLocationController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: prediction.description!.length),
                            );
                          },
                          itemBuilder: (context, index, Prediction prediction) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Expanded(
                                      child: Text(
                                          "${prediction.description ?? ""}")),
                                ],
                              ),
                            );
                          },
                          isCrossBtnShown: true,
                        ),
                      ],
                    ),
            ),
          ),
          Visibility(
            visible: isSelectedLocation,
            child: Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isCar = true;
                                isBike = false;
                                isTuk = false;
                              });
                            },
                            child: Container(
                              decoration: isCar
                                  ? BoxDecoration(
                                      color: Color.fromARGB(255, 246, 244, 244),
                                      border: Border.all(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                  : BoxDecoration(),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Car"),
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset('assets/images/car.png'),
                                  ),
                                  Text(distance),
                                  carCharge == 0.0
                                      ? Text(
                                          'Calculating...',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          'LKR ${carCharge.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isCar = false;
                                isBike = false;
                                isTuk = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: isTuk
                                  ? BoxDecoration(
                                      color: Color.fromARGB(255, 246, 244, 244),
                                      border: Border.all(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                  : BoxDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Tuk"),
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset('assets/images/tuk.png'),
                                  ),
                                  Text(distance),
                                  tukCharge == 0.0
                                      ? Text(
                                          'Calculating...',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          'LKR ${tukCharge.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isCar = false;
                                isBike = true;
                                isTuk = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: isBike
                                  ? BoxDecoration(
                                      color: Color.fromARGB(255, 246, 244, 244),
                                      border: Border.all(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                  : BoxDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Bike"),
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset(
                                        'assets/images/bikeSelect.png'),
                                  ),
                                  Text(distance),
                                  bikeCharge == 0.0
                                      ? Text(
                                          'Calculating...',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          'LKR ${bikeCharge.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      text: 'CONFIRM',
                      height: 50,
                      width: screenWidth,
                      backgroundColor: AppColors.buttonColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
