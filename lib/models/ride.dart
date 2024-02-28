import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ride {
  final String rideID;
  final String passengerID;
  final LatLng picupLocation;
  final LatLng dropLocation;
  final String vehicleType;
  final double totalKMs;
  final double totalPrice;
  final String pickupAddress;
  final String dropAddresss;
  final String date;
  final String driverID;
  final double ratingStars;
  final String ratingComment;

  Ride({
    required this.rideID,
    required this.passengerID,
    required this.picupLocation,
    required this.dropLocation,
    required this.vehicleType,
    required this.totalKMs,
    required this.totalPrice,
    required this.dropAddresss,
    required this.pickupAddress,
    required this.date,
    required this.driverID,
    required this.ratingStars,
    required this.ratingComment,
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
      'pickAddress': pickupAddress,
      'dropAddress': dropAddresss,
      'trip_Date': date,
      'driver_ID': driverID,
      'rating_Starts': ratingStars,
      'rating_Comment': ratingComment,
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
      pickupAddress: json['pickAddress'],
      dropAddresss: json['dropAddress'],
      date: json['Registed_Date'],
      driverID: json['driver_ID'],
      ratingStars: json['rating_Starts'] ?? 0.0,
      ratingComment: json['rating_Comment'],
    );
  }
}
