import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/global/global.dart';
import 'package:taxia/providers/map/map_provider.dart';
import 'package:taxia/providers/ride/ride_provider.dart';
import 'package:taxia/providers/user/user_provider.dart';
import 'package:taxia/views/search_driver/search_driver.dart';
import 'package:taxia/widgets/custom_button.dart';
import 'package:uuid/uuid.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('rides');

  late Uint8List customMarkerIcon;

  String rideID = '';

  bool isSelectedLocation = false;

  bool isCar = false;
  bool isTuk = false;
  bool isBike = false;
  bool isVan = false;
  bool isLorry = false;

  //subVehicleCar
  bool isBudgetCar = false;
  bool isMiniCar = false;
  bool isSedanCar = false;

  //subVehicleVan
  bool isMiniVan = false;
  bool isNonACVan = false;
  bool isNormalACVan = false;
  bool isKDHFlatroofVan = false;
  bool isKDHHighroofVan = false;

  String selectedVehicle = '';
  String selectedSubVehicle = '';

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

  bool isLoading = false;

  @override
  void initState() {
    loadCustomMaker();
    getUserID();
    generateRideID();
    super.initState();
  }

  generateRideID() {
    setState(() {
      rideID = Uuid().v4();
    });
  }

  String? userID = '';

  getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
    });
  }

  getVehicleRates() {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    mapProvider.isLoading = true;
    mapProvider.getVehicleRates(context);
  }

  loadCustomMaker() async {
    customMarkerIcon = await loadAsset('assets/images/man.png', 125);
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openAppSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemark[0];

    setState(() {
      pickupLocationController.text =
          '${place.street}, ${place.subLocality}, ${place.locality}';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
                  polylineId: const PolylineId("route"),
                  points: polylineCordinates,
                  visible: true,
                  width: 3,
                  color: const ui.Color.fromARGB(255, 18, 7, 212),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: Platform.isIOS
                                ? AppBar().preferredSize.height - 15
                                : null,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/home', (route) => false);
                            },
                            child: Container(
                              height: 40,
                              width: 100,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: AppColors.accentColor,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Icon(
                                    Icons.home,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              children: [
                                const Text(
                                  "Pickup - ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(pickupLocationController.text),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/map');
                                  },
                                  child: const Icon(
                                    Icons.change_circle,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: screenWidth,
                            padding: const EdgeInsets.symmetric(
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
                                const Text(
                                  "Drop - ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(endLocationController.text),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/map');
                                  },
                                  child: const Icon(
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: Platform.isIOS
                                ? AppBar().preferredSize.height - 15
                                : null,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/home', (route) => false);
                            },
                            child: Container(
                              height: 40,
                              width: 100,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: AppColors.accentColor,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Icon(
                                    Icons.home,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  Position position =
                                      await _determinePosition();

                                  getAddressFromLatLong(position);
                                },
                                child: Icon(Icons.my_location),
                              ),
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
                                  markerId: const MarkerId('start'),
                                  position: pickupLocation!,
                                  infoWindow:
                                      const InfoWindow(title: 'Start Location'),
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
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on),
                                    const SizedBox(
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
                          const SizedBox(
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
                                  markerId: const MarkerId('end'),
                                  position: endLocation!,
                                  infoWindow:
                                      const InfoWindow(title: 'End Location'),
                                ),
                              );

                              // Call the drawPolyline method
                              drowPolyline('start-end');

                              CameraPosition cameraPosition = CameraPosition(
                                  target: pickupLocation!, zoom: 13);

                              controllerGoogleMap!.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      cameraPosition));
                              print(pickupLocation);

                              //focusCameraOnPickupAndEndLocations();
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
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on),
                                    const SizedBox(
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
            Visibility(
              visible: isSelectedLocation,
              child: Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCar = true;
                                  isVan = false;
                                  isBike = false;
                                  isLorry = false;
                                  isTuk = false;
                                  isNormalACVan = false;
                                  isMiniVan = false;
                                  isNonACVan = false;
                                  isVan = false;
                                  isKDHFlatroofVan = false;
                                  isKDHHighroofVan = false;
                                  selectedVehicle = 'car';
                                });
                              },
                              child: Container(
                                decoration: isCar
                                    ? BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 246, 244, 244),
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : const BoxDecoration(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Car"),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: SizedBox(
                                        height: 50,
                                        child: Image.asset(
                                            'assets/images/car.png'),
                                      ),
                                    ),
                                    Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km'),
                                    Text(
                                      'LKR ${(mapProvider.carCharge * mapProvider.distance).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCar = false;
                                  isBike = false;
                                  isTuk = false;
                                  isVan = true;
                                  isLorry = false;
                                  isBudgetCar = false;
                                  isMiniCar = false;
                                  isSedanCar = false;
                                  selectedVehicle = 'van';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: isVan
                                    ? BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 246, 244, 244),
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : const BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Van"),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: SizedBox(
                                        height: 50,
                                        child: Image.asset(
                                            'assets/images/van.png'),
                                      ),
                                    ),
                                    Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km'),
                                    Text(
                                      'LKR ${(mapProvider.bikeCharge * mapProvider.distance).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCar = false;
                                  isBike = false;
                                  isTuk = false;
                                  isVan = false;
                                  isLorry = true;
                                  isMiniCar = false;
                                  isBudgetCar = false;
                                  isSedanCar = false;
                                  isNormalACVan = false;
                                  isMiniVan = false;
                                  isNonACVan = false;
                                  isVan = false;
                                  isKDHFlatroofVan = false;
                                  isKDHHighroofVan = false;
                                  selectedVehicle = 'lorry';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: isLorry
                                    ? BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 246, 244, 244),
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : const BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Lorry"),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: SizedBox(
                                        height: 50,
                                        child: Image.asset(
                                            'assets/images/lorry.png'),
                                      ),
                                    ),
                                    Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km'),
                                    Text(
                                      'LKR ${(mapProvider.tukCharge * mapProvider.distance).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCar = false;
                                  isLorry = false;
                                  isBike = false;
                                  isTuk = true;
                                  isVan = false;
                                  isMiniCar = false;
                                  isBudgetCar = false;
                                  isSedanCar = false;
                                  isNormalACVan = false;
                                  isMiniVan = false;
                                  isNonACVan = false;
                                  isKDHFlatroofVan = false;
                                  isKDHHighroofVan = false;
                                  selectedVehicle = 'tuk';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: isTuk
                                    ? BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 246, 244, 244),
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : const BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Tuk"),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: SizedBox(
                                        height: 50,
                                        child: Image.asset(
                                            'assets/images/tuk.png'),
                                      ),
                                    ),
                                    Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km'),
                                    Text(
                                      'LKR ${(mapProvider.tukCharge * mapProvider.distance).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCar = false;
                                  isBike = true;
                                  isTuk = false;
                                  isVan = false;
                                  isLorry = false;
                                  isMiniCar = false;
                                  isBudgetCar = false;
                                  isSedanCar = false;
                                  isNormalACVan = false;
                                  isMiniVan = false;
                                  isNonACVan = false;
                                  isKDHFlatroofVan = false;
                                  isKDHHighroofVan = false;
                                  selectedVehicle = 'bike';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: isBike
                                    ? BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 246, 244, 244),
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : const BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Bike"),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: SizedBox(
                                        height: 50,
                                        child: Image.asset(
                                            'assets/images/bikeSelect.png'),
                                      ),
                                    ),
                                    Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km'),
                                    Text(
                                      'LKR ${(mapProvider.bikeCharge * mapProvider.distance).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isVan || isCar,
                        child: Divider(),
                      ),
                      Visibility(
                        visible: isCar,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isBudgetCar = true;
                                    isMiniCar = false;
                                    isSedanCar = false;
                                    isVan = false;
                                    selectedSubVehicle = 'budgetcar';
                                  });
                                },
                                child: Container(
                                  decoration: isBudgetCar
                                      ? BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 246, 244, 244),
                                          border: Border.all(
                                            color: Colors.blue,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : const BoxDecoration(),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Budget Car",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: SizedBox(
                                          height: 35,
                                          child: Image.asset(
                                              'assets/images/car.png'),
                                        ),
                                      ),
                                      Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'LKR ${(mapProvider.carCharge * mapProvider.distance).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isBudgetCar = false;
                                    isMiniCar = true;
                                    isVan = false;
                                    isSedanCar = false;
                                    selectedSubVehicle = 'minicar';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: isMiniCar
                                      ? BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 246, 244, 244),
                                          border: Border.all(
                                            color: Colors.blue,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : const BoxDecoration(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Mini Car",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: SizedBox(
                                          height: 35,
                                          child: Image.asset(
                                              'assets/images/mini_car.png'),
                                        ),
                                      ),
                                      Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'LKR ${(mapProvider.tukCharge * mapProvider.distance).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isBudgetCar = false;
                                    isVan = false;
                                    isMiniCar = false;
                                    isSedanCar = true;
                                    selectedSubVehicle = 'sedancar';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: isSedanCar
                                      ? BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 246, 244, 244),
                                          border: Border.all(
                                            color: Colors.blue,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : const BoxDecoration(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Sedan Car",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: SizedBox(
                                          height: 35,
                                          child: Image.asset(
                                              'assets/images/sedan_car.png'),
                                        ),
                                      ),
                                      Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'LKR ${(mapProvider.bikeCharge * mapProvider.distance).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //isVan
                      Visibility(
                        visible: isVan,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isNormalACVan = true;
                                    isMiniVan = false;
                                    isNonACVan = false;
                                    isCar = false;
                                    isKDHFlatroofVan = false;
                                    isKDHHighroofVan = false;
                                    selectedSubVehicle = 'normalACVan';
                                  });
                                },
                                child: Container(
                                  decoration: isNormalACVan
                                      ? BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 246, 244, 244),
                                          border: Border.all(
                                            color: Colors.blue,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : const BoxDecoration(),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Normal AC Van",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: SizedBox(
                                          height: 35,
                                          child: Image.asset(
                                              'assets/images/van.png'),
                                        ),
                                      ),
                                      Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'LKR ${(mapProvider.carCharge * mapProvider.distance).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isCar = false;
                                    isNormalACVan = false;
                                    isMiniVan = true;
                                    isNonACVan = false;
                                    isKDHFlatroofVan = false;
                                    isKDHHighroofVan = false;
                                    selectedSubVehicle = 'miniVan';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: isMiniVan
                                      ? BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 246, 244, 244),
                                          border: Border.all(
                                            color: Colors.blue,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : const BoxDecoration(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Mini Van",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: SizedBox(
                                          height: 35,
                                          child: Image.asset(
                                              'assets/images/mini_van.png'),
                                        ),
                                      ),
                                      Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'LKR ${(mapProvider.tukCharge * mapProvider.distance).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isNormalACVan = false;
                                    isMiniVan = false;
                                    isCar = false;
                                    isNonACVan = true;
                                    isKDHFlatroofVan = false;
                                    isKDHHighroofVan = false;
                                    selectedSubVehicle = 'nonACVan';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: isNonACVan
                                      ? BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 246, 244, 244),
                                          border: Border.all(
                                            color: Colors.blue,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : const BoxDecoration(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Non AC Van",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: SizedBox(
                                          height: 35,
                                          child: Image.asset(
                                              'assets/images/non_ac_van.png'),
                                        ),
                                      ),
                                      Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'LKR ${(mapProvider.bikeCharge * mapProvider.distance).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isNormalACVan = false;
                                    isMiniVan = false;
                                    isCar = false;
                                    isNonACVan = false;
                                    isKDHFlatroofVan = true;
                                    isKDHHighroofVan = false;
                                    selectedSubVehicle = 'kDHFlatroofVan';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: isKDHFlatroofVan
                                      ? BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 246, 244, 244),
                                          border: Border.all(
                                            color: Colors.blue,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : const BoxDecoration(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "KDH Flatroof Van",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: SizedBox(
                                          height: 35,
                                          child: Image.asset(
                                              'assets/images/kdh_flatroof_van.png'),
                                        ),
                                      ),
                                      Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'LKR ${(mapProvider.tukCharge * mapProvider.distance).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isCar = false;
                                    isNormalACVan = false;
                                    isMiniVan = false;
                                    isNonACVan = false;
                                    isKDHFlatroofVan = false;
                                    isKDHHighroofVan = true;
                                    selectedSubVehicle = 'kDHHighroofVan';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: isKDHHighroofVan
                                      ? BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 246, 244, 244),
                                          border: Border.all(
                                            color: Colors.blue,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )
                                      : const BoxDecoration(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "KDH Highroof Van",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: SizedBox(
                                          height: 35,
                                          child: Image.asset(
                                              'assets/images/kdh_highroof_an.png'),
                                        ),
                                      ),
                                      Text(
                                        '${mapProvider.distance.toStringAsFixed(1)} Km',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'LKR ${(mapProvider.bikeCharge * mapProvider.distance).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer(
                        builder: (BuildContext context,
                                RideProvider rideProvider, Widget? child) =>
                            Visibility(
                          visible: (isCar && isBudgetCar ||
                                  isMiniCar ||
                                  isSedanCar) ||
                              (isVan && isMiniVan ||
                                  isNonACVan ||
                                  isNormalACVan ||
                                  isKDHFlatroofVan ||
                                  isKDHHighroofVan) ||
                              isLorry ||
                              isTuk ||
                              isBike,
                          child: GestureDetector(
                            onTap: () async {
                              await userProvider.getUserData();

                              double totalCharge = 0.0;

                              if (selectedVehicle == 'car') {
                                totalCharge = mapProvider.carCharge *
                                    mapProvider.distance;
                              } else if (selectedVehicle == 'tuk') {
                                totalCharge = mapProvider.tukCharge *
                                    mapProvider.distance;
                              } else if (selectedVehicle == 'bike') {
                                totalCharge = mapProvider.bikeCharge *
                                    mapProvider.distance;
                              } else {
                                0.0;
                              }

                              databaseReference.child(rideID).set({
                                "rideID": rideID,
                                "pID": userID,
                                "picupLocationLong": pickupLocation!.longitude,
                                "picupLocationLat": pickupLocation!.latitude,
                                "dropLocationLong": endLocation!.longitude,
                                "dropLocationLat": endLocation!.latitude,
                                "vehicleType": selectedVehicle,
                                "totalKm": mapProvider.distance.toDouble(),
                                "totalPrice": totalCharge,
                                "pickupAddress": pickupLocationController.text,
                                "dropAddress": endLocationController.text,
                              });

                              // rideProvider.confirmRide(
                              //   Ride(
                              //     rideID: rideID,
                              //     passengerID: userID!,
                              //     picupLocation: pickupLocation!,
                              //     dropLocation: endLocation!,
                              //     vehicleType: selectedVehicle,
                              //     totalKMs: mapProvider.distance,
                              //     totalPrice: totalCharge,
                              //     dropAddresss: endLocationController.text,
                              //     pickupAddress: pickupLocationController.text,
                              //   ),
                              //   userID!,
                              //   context,
                              //   rideID,
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchDriver(
                                    pickupLocation: pickupLocation!,
                                    selectedVehicle: selectedVehicle,
                                    userID: userID!,
                                    rideID: rideID,
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
                        ),
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
