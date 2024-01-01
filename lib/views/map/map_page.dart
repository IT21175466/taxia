import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/global/global.dart';
import 'package:taxia/providers/map/map_provider.dart';
import 'package:taxia/views/search_driver/search_driver.dart';
import 'package:taxia/widgets/custom_button.dart';

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

  String selectedVehicle = 'car';

  Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  LatLng? pickupLocation;
  LatLng? endLocation;

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
    super.initState();
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
          CameraUpdate.newLatLngBounds(bounds, 80.0),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Consumer(
        builder:
            (BuildContext context, MapProvider mapProvider, Widget? child) =>
                Stack(
          children: [
            GoogleMap(
              markers: markers,
              zoomControlsEnabled: false,
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: polylineCordinates,
                  visible: true,
                  width: 3,
                  color: ui.Color.fromARGB(255, 18, 7, 212),
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
                          SizedBox(
                            height: Platform.isIOS
                                ? AppBar().preferredSize.height - 15
                                : null,
                          ),
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
                                    Navigator.pushReplacementNamed(
                                        context, '/map');
                                  },
                                  child: Icon(
                                    Icons.change_circle,
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
                                    Navigator.pushReplacementNamed(
                                        context, '/map');
                                  },
                                  child: Icon(
                                    Icons.change_circle,
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
                          SizedBox(
                            height: Platform.isIOS
                                ? AppBar().preferredSize.height - 15
                                : null,
                          ),
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
                                  infoWindow:
                                      InfoWindow(title: 'Start Location'),
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
                            itemBuilder:
                                (context, index, Prediction prediction) {
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
                                          "${prediction.description ?? ""}"),
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

                              mapProvider.getDistance(
                                startLatitude: pickupLocation!.latitude,
                                startLongitude: pickupLocation!.longitude,
                                endLatitude: endLocation!.latitude,
                                endLongitude: endLocation!.longitude,
                              );

                              //calculateCharges();
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
                            itemBuilder:
                                (context, index, Prediction prediction) {
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
                  padding: EdgeInsets.all(15),
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
                                  selectedVehicle = 'car';
                                });
                              },
                              child: Container(
                                decoration: isCar
                                    ? BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 246, 244, 244),
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
                                      child:
                                          Image.asset('assets/images/car.png'),
                                    ),
                                    Text(mapProvider.distance
                                            .toStringAsFixed(1) +
                                        ' Km'),
                                    mapProvider.carCharge == 0.0
                                        ? Text(
                                            'Calculating...',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Text(
                                            'LKR ${(mapProvider.carCharge * mapProvider.distance).toStringAsFixed(2)}',
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
                                  selectedVehicle = 'tuk';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: isTuk
                                    ? BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 246, 244, 244),
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
                                      child:
                                          Image.asset('assets/images/tuk.png'),
                                    ),
                                    Text(mapProvider.distance
                                            .toStringAsFixed(1) +
                                        ' Km'),
                                    mapProvider.tukCharge == 0.0
                                        ? Text(
                                            'Calculating...',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Text(
                                            'LKR ${(mapProvider.tukCharge * mapProvider.distance).toStringAsFixed(2)}',
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
                                  selectedVehicle = 'bike';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: isBike
                                    ? BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 246, 244, 244),
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
                                    Text(mapProvider.distance
                                            .toStringAsFixed(1) +
                                        ' Km'),
                                    mapProvider.bikeCharge == 0.0
                                        ? Text(
                                            'Calculating...',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Text(
                                            'LKR ${(mapProvider.bikeCharge * mapProvider.distance).toStringAsFixed(2)}',
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchDriver(
                                pickupLocation: pickupLocation!,
                                selectedVehicle: selectedVehicle,
                              ),
                            ),
                          );
                        },
                        child: CustomButton(
                          text: 'CONFIRM',
                          height: 50,
                          width: screenWidth,
                          backgroundColor: AppColors.buttonColor,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: Platform.isIOS ? 15 : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
