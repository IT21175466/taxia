import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxia/models/user.dart';

class UserProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  bool loading = false;

  String _selectedRole = "Select Your Role";

  String get selectedRole => _selectedRole;

  set selectedRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  addUserToFirebase(User user, BuildContext context, String uID) async {
    if (selectedRole == "User") {
      try {
        db.collection("Users").doc(uID).set(user.toJson()).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User Registration Success!"),
            ),
          );
          loading = false;
          Navigator.pushReplacementNamed(context, '/splash');
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
    } else if (selectedRole == "Driver") {
      try {
        db.collection("Drivers").doc(uID).set(user.toJson()).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Driver Registration Success!"),
            ),
          );
          loading = false;
          Navigator.pushReplacementNamed(context, '/splash');
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
}
