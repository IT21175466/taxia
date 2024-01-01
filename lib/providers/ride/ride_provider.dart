import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxia/models/ride.dart';

class RideProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  bool loading = false;

  confirmRide(Ride ride, BuildContext context) async {
    try {
      db.collection("Rides").doc().set(ride.toJson()).then((value) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Searching Drivers...."),
          ),
        );

        loading = false;
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      notifyListeners();
    }
  }
}
