import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxia/models/ride.dart';

class RideProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  bool loading = false;
  bool isLoading = false;

  double availablePoints = 0.0;

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
    }
  }

  updateReviewToDriver(String driverID, String rideID, double ratingStars,
      String ratingComment) async {
    isLoading = true;
    notifyListeners();
    try {
      await db
          .collection("Rides")
          .doc(driverID)
          .collection("Users")
          .doc(rideID)
          .update(
              {'rating_Starts': ratingStars, 'rating_Comment': ratingComment});

      DocumentSnapshot documentSnap =
          await db.collection("Drivers").doc(driverID).get();

      availablePoints = double.parse(documentSnap.get('Points').toString());
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      await db.collection("Drivers").doc(driverID).update(
            ({'Points': availablePoints + ratingStars}),
          );
      isLoading = false;
      notifyListeners();
    }
  }

  updateReviewToUser(String passengerID, String rideID, double ratingStars,
      String ratingComment) async {
    isLoading = true;
    notifyListeners();
    try {
      await db
          .collection("Rides")
          .doc(passengerID)
          .collection("Users")
          .doc(rideID)
          .update(
              {'rating_Starts': ratingStars, 'rating_Comment': ratingComment});

      DocumentSnapshot documentSnap =
          await db.collection("Users").doc(passengerID).get();

      availablePoints = double.parse(documentSnap.get('Points').toString());
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      await db.collection("Users").doc(passengerID).update(
            ({'Points': availablePoints + ratingStars}),
          );
    }
    isLoading = false;
    notifyListeners();
  }

  confirmRideToDriver(
      Ride ride, String driverID, BuildContext context, String rideID) async {
    loading = true;
    try {
      db
          .collection("Rides")
          .doc(driverID)
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
    }
  }
}
