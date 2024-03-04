import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/models/user.dart';

class UserProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  bool loading = false;
  String? userID = '';
  String? phoneNumber = '...';
  String? email = '...';
  String? province = '...';
  String? fistName = '...';
  String? lastName = '...';
  String? district = '...';
  double? points = 0.0;
  bool noCoupens = false;
  //Driver
  String? address = '...';
  String? birthDay = '...';
  String? gender = '...';
  String? model = '...';
  String? brand = '...';
  String? vehicleNumber = '...';
  String? vehicleType = '...';
  bool isDriver = false;

  int totalCouponHours = 0;
  int availableTime = 0;
  double progress = 0.0;

  addUserToFirebase(User user, BuildContext context, String uID) async {
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
  }

  getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    notifyListeners();
  }

  getDriverAccountInfo() async {
    await getUserID();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference documentRef =
          firestore.collection("Drivers").doc(userID);

      DocumentSnapshot docSnapshot = await documentRef.get();

      if (docSnapshot.exists) {
        print("Driver document exists");
        notifyListeners();

        final DocumentSnapshot documentRefDrivers = await FirebaseFirestore
            .instance
            .collection("Drivers")
            .doc(userID)
            .get();

        isDriver = true;
        fistName = documentRefDrivers.get('firstName');
        lastName = documentRefDrivers.get('lastName');
        phoneNumber = documentRefDrivers.get('telephone');
        email = documentRefDrivers.get('email');
        // district = documentRefDrivers.get('District');
        // province = documentRefDrivers.get('Province');
        //
        address = documentRefDrivers.get('address');
        points = double.parse(documentRefDrivers.get('Points').toString());
        birthDay = documentRefDrivers.get('birthday');
        gender = documentRefDrivers.get('gender');
        model = documentRefDrivers.get('model');
        brand = documentRefDrivers.get('brand');
        vehicleNumber = documentRefDrivers.get('vehicleNumber');
        vehicleType = documentRefDrivers.get('whichVehicle');
        notifyListeners();
      }
    } catch (error) {
      print("Error checking document: $error");
    }
  }

  Future<void> getDriverCoupens() async {
    await getUserID();
    FirebaseFirestore.instance
        .collection('Coupons')
        .doc(userID)
        .collection('coupon')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        noCoupens = true;
        notifyListeners();
      } else {
        noCoupens = false;
        querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          //add all (couponAmount * couponTime) to totalCouponHours variable
          final couponData = documentSnapshot.data() as Map<String, dynamic>;
          int couponAmount = int.parse(couponData['couponAmount'].toString());
          int couponTime = int.parse(couponData['couponTime'].toString());

          availableTime += int.parse(DateTime.parse(couponData['couponEndOn'])
              .difference(DateTime.now())
              .inHours
              .toString());

          // Add couponAmount * couponTime to totalCouponHours
          totalCouponHours += couponAmount * couponTime;
          print(totalCouponHours);
          print(availableTime);

          progress = double.parse(availableTime.toString()) /
              double.parse(totalCouponHours.toString());

          print(progress);

          notifyListeners();
        });
      }
    });
  }

  getUserAccountInfo() async {
    await getUserID();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      //Users
      DocumentReference documentRefUsers =
          firestore.collection("Users").doc(userID);

      DocumentSnapshot docSnapshotUsers = await documentRefUsers.get();

      if (docSnapshotUsers.exists) {
        print("User document exists");
        notifyListeners();

        fistName = docSnapshotUsers.get('FirstName');
        lastName = docSnapshotUsers.get('LastName');
        phoneNumber = docSnapshotUsers.get('PhoneNumber');
        email = docSnapshotUsers.get('Email');
        points = double.parse(docSnapshotUsers.get('Points').toString());
        district = docSnapshotUsers.get('District');
        province = docSnapshotUsers.get('Province');
        //

        notifyListeners();
      }
    } catch (error) {
      print("Error checking document: $error");
    }
  }

  // getUserInfo() async {
  //   try {
  //     final DocumentSnapshot usersDoc = await FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(userID)
  //         .get();

  //     if (usersDoc.exists) {
  //       fistName = usersDoc.get('FirstName');
  //       lastName = usersDoc.get('LastName');
  //       phoneNumber = usersDoc.get('PhoneNumber');
  //       email = usersDoc.get('Email');
  //       district = usersDoc.get('District');
  //       province = usersDoc.get('Province');
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     loading = false;
  //     notifyListeners();
  //   }
  // }

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
