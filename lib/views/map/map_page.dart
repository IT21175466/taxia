import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:taxia/global/global.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Uint8List customMarkerIcon;

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
    customMarkerIcon = await loadAsset('assets/images/destination.png', 150);
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
                color: Colors.green,
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
              child: Column(
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
                    googleAPIKey: "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
                    inputDecoration: InputDecoration(
                      hintText: "Pickup Location",
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
                      pickupLocation = LatLng(
                        double.parse(prediction.lat.toString()),
                        double.parse(prediction.lng.toString()),
                      );

                      markers.add(
                        Marker(
                          icon: BitmapDescriptor.defaultMarker,
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
                      pickupLocationController.text = prediction.description!;
                      pickupLocationController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
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
                              child: Text("${prediction.description ?? ""}"),
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
                    googleAPIKey: "AIzaSyDWlxEQU9GMmFEmZwiT3OGVVxTyc984iNY",
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
                          icon: BitmapDescriptor.fromBytes(customMarkerIcon),
                          markerId: MarkerId('end'),
                          position: endLocation!,
                          infoWindow: InfoWindow(title: 'End Location'),
                        ),
                      );

                      // Call the drawPolyline method
                      drowPolyline('start-end');

                      focusCameraOnPickupAndEndLocations();

                      //print(endLocation);
                    },
                    itemClick: (Prediction prediction) {
                      endLocationController.text = prediction.description!;
                      endLocationController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
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
                                child: Text("${prediction.description ?? ""}")),
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
        ],
      ),
    );
  }
}
