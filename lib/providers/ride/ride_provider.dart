import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxia/models/ride.dart';

class RideProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  bool loading = false;

  confirmRide(
      Ride ride, String userID, BuildContext context, String rideID) async {
    loading = true;
    try {
      db
          .collection("Rides")
          .doc(userID)
          .collection('Users')
          .doc(rideID)
          .set(ride.toJson())
          .then((value) async {
        loading = false;
        notifyListeners();
        print('Added');
      });
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      notifyListeners();
    } finally {
      loading = false;
      Navigator.pushNamedAndRemoveUntil(
          context, '/drivermap', (route) => false);
    }
  }
}
