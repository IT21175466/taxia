import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

InfoWindow customInfoWindow(BuildContext context, double distance) {
  return InfoWindow(
    title: "In ${distance} KM",
    snippet: "Tap to get",
  );
}
