import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ride {
  final String rideID;
  final String passengerID;
  final LatLng picupLocation;
  final LatLng dropLocation;
  final String vehicleType;
  final double totalKMs;
  final double totalPrice;

  Ride({
    required this.rideID,
    required this.passengerID,
    required this.picupLocation,
    required this.dropLocation,
    required this.vehicleType,
    required this.totalKMs,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'rideID': rideID,
      'passengerID': passengerID,
      'picupLocation': {
        'latitude': picupLocation.latitude,
        'longitude': picupLocation.longitude,
      },
      'dropLocation': {
        'latitude': dropLocation.latitude,
        'longitude': dropLocation.longitude,
      },
      'vehicleType': vehicleType,
      'totalKMs': totalKMs,
      'totalPrice': totalPrice,
    };
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      rideID: json['rideID'],
      passengerID: json['passengerID'],
      picupLocation: LatLng(
        json['picupLocation']['latitude'],
        json['picupLocation']['longitude'],
      ),
      dropLocation: LatLng(
        json['dropLocation']['latitude'],
        json['dropLocation']['longitude'],
      ),
      vehicleType: json['vehicleType'],
      totalKMs: json['totalKMs'],
      totalPrice: json['totalPrice'],
    );
  }
}
