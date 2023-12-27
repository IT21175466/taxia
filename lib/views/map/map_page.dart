import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxia/widgets/google_autocomplete_textFiled.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String? _mapStyle;

  late LatLng pickup;
  late LatLng end;

  Set<Marker> markers = Set<Marker>();

  GoogleMapController? mapController;

  final TextEditingController pickupLocationController =
      TextEditingController();
  final TextEditingController endLocationController = TextEditingController();

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController!.setMapStyle(_mapStyle);
            },
            initialCameraPosition: CameraPosition(
              target: _pGooglePlex,
              zoom: 13,
            ),
          ),
          inputFiledsContainer(),
        ],
      ),
    );
  }

  Widget inputFiledsContainer() {
    return Positioned(
      top: 30,
      left: 20,
      right: 20,
      child: Container(
        child: Column(
          children: [
            GoogleAutoCompleteTextFiled(
              controller: pickupLocationController,
              hintText: 'Pickup Location',
              onPlaceSelected: (place) {
                //_handlePickupLocationSelected(place);
              },
            ),
            GoogleAutoCompleteTextFiled(
              controller: endLocationController,
              hintText: 'Where are you going?',
              onPlaceSelected: (place) {
                //_handleEndLocationSelected(place);
              },
            ),
          ],
        ),
      ),
    );
  }
}
