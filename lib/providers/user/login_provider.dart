import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxia/views/home_screen/home_page.dart';

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
        print("Document exists: ${docSnapshot.data()}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        notifyListeners();
      } else if (docSnapshotUsers.exists) {
        print("Document exists: ${docSnapshot.data()}");
        Navigator.pushReplacementNamed(context, '/home');
        notifyListeners();
      } else {
        print("Document does not exist");
        Navigator.pushReplacementNamed(context, '/signup');
        notifyListeners();
      }
    } catch (error) {
      print("Error checking document: $error");
    }
  }
}
