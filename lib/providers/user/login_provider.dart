import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  checkUserIsSignUp(String userID, BuildContext context) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference documentRef =
          firestore.collection("Drivers").doc(userID);

      DocumentSnapshot docSnapshot = await documentRef.get();

      //Users
      DocumentReference documentRefUsers =
          firestore.collection("Users").doc(userID);

      DocumentSnapshot docSnapshotUsers = await documentRefUsers.get();

      if (docSnapshot.exists) {
        print("Driver document exists: ${docSnapshot.data()}");
        notifyListeners();

        Navigator.pushReplacementNamed(
            context, '/home'); // Navigate to driver home page , shoud modify

        notifyListeners();
      } else if (docSnapshotUsers.exists) {
        print("User document exists: ${docSnapshot.data()}");
        Navigator.pushReplacementNamed(context, '/home');
        notifyListeners();
      } else {
        print("Any document does not exist");
        Navigator.pushReplacementNamed(context, '/typeselection');
        notifyListeners();
      }
    } catch (error) {
      print("Error checking document: $error");
    }
  }
}
