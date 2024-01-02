import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        db.collection("Users").doc(uID).set(user.toJson()).then((value) async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('logedIn', true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User Registration Success!"),
            ),
          );

          loading = false;
          Navigator.pushReplacementNamed(context, '/home');
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
        db
            .collection("Drivers")
            .doc(uID)
            .set(user.toJson())
            .then((value) async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('logedIn', true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Driver Registration Success!"),
            ),
          );

          loading = false;
          Navigator.pushReplacementNamed(context, '/home');
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

  getUserData() async {
    try {
      auth.User? user = auth.FirebaseAuth.instance.currentUser;

      final DocumentSnapshot usersDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .get();

      if (usersDoc.exists) {
        print(usersDoc);
        return User.fromJson(usersDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  logOutUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('logedIn', false);
  }
}
