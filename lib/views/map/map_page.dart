import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:taxia/global/global.dart';
import 'package:taxia/providers/map/map_provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Uint8List customMarkerIcon;

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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, MapProvider mapProvider, Widget? child) =>
          Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              markers: mapProvider.markers,
              zoomControlsEnabled: false,
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: mapProvider.polylineCordinates,
                  visible: true,
                  width: 5,
                  color: Colors.green,
                ),
              },
              onMapCreated: (GoogleMapController mapController) {
                if (!mapProvider.googleMapCompleterController.isCompleted) {
                  mapProvider.googleMapCompleterController
                      .complete(mapController);
                  mapProvider.controllerGoogleMap = mapController;
                } else {
                  mapProvider.controllerGoogleMap = mapController;
                  mapProvider.pickupLocationController.text = '';
                  mapProvider.endLocationController.text = '';
                  mapProvider.pickupLocation = null;
                  mapProvider.endLocation = null;
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
                      textEditingController:
                          mapProvider.pickupLocationController,
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
                        mapProvider.updateUI();
                        mapProvider.pickupLocation = LatLng(
                          double.parse(prediction.lat.toString()),
                          double.parse(prediction.lng.toString()),
                        );

                        mapProvider.markers.add(
                          Marker(
                            icon: BitmapDescriptor.defaultMarker,
                            markerId: MarkerId('start'),
                            position: mapProvider.pickupLocation!,
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
                        mapProvider.pickupLocationController.text =
                            prediction.description!;
                        mapProvider.pickupLocationController.selection =
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
                      textEditingController: mapProvider.endLocationController,
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
                        mapProvider.endLocation = LatLng(
                          double.parse(prediction.lat.toString()),
                          double.parse(prediction.lng.toString()),
                        );

                        mapProvider.markers.add(
                          Marker(
                            icon: BitmapDescriptor.fromBytes(customMarkerIcon),
                            markerId: MarkerId('end'),
                            position: mapProvider.endLocation!,
                            infoWindow: InfoWindow(title: 'End Location'),
                          ),
                        );

                        // Call the drawPolyline method
                        mapProvider.drowPolyline('start-end');

                        mapProvider.focusCameraOnPickupAndEndLocations();

                        //print(endLocation);
                      },
                      itemClick: (Prediction prediction) {
                        mapProvider.endLocationController.text =
                            prediction.description!;
                        mapProvider.endLocationController.selection =
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
                                  child:
                                      Text("${prediction.description ?? ""}")),
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
      ),
    );
  }
}
