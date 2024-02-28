import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Driver.dart';

class Teamandcondition extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String birthday;
  final String gender;
  final String telephone;
  final String email;
  final String address;
  final bool isVehicleOwner;

  final String faceimg;
  final String nicfont;
  final String nicback;
  final String drivingfont;
  final String drivingback;
  final String selectvehical;

  final String vehicalnumber;
  final String band;
  final String model;
  final String vehicalimg;

  final bool onlyMyVehicle;

  const Teamandcondition({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.telephone,
    required this.email,
    required this.address,
    required this.isVehicleOwner,
    required this.faceimg,
    required this.nicfont,
    required this.nicback,
    required this.drivingfont,
    required this.drivingback,
    required this.selectvehical,
    required this.vehicalnumber,
    required this.band,
    required this.model,
    required this.vehicalimg,
    required this.onlyMyVehicle,
  });

  Future<void> saveDriver(Driver driver, String dID) async {
    CollectionReference driversCollection =
        FirebaseFirestore.instance.collection('Drivers');
    await driversCollection.doc(dID).set(driver.toMap());
  }

  @override
  State<Teamandcondition> createState() => _TeamandconditionState();
}

class _TeamandconditionState extends State<Teamandcondition> {
  String? driverID = '';

  getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      driverID = prefs.getString('userID');
    });
  }

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  ListTileTitleAlignment? titleAlignment;
  bool checkboxValue2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 242, 0),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        title: Text(
          "Driver Registration Form",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info, size: 20, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Driver Registration Terms and Conditions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ListTile(
                titleAlignment: titleAlignment,
                title: const Text('Acceptance of Terms'),
                subtitle: const Text(
                    'By registering as a driver on this mobile application, you agree to comply with and be bound by these terms and conditions. If you do not agree with any part of these terms, please do not proceed with the registration process.'),
              ),
              ListTile(
                titleAlignment: titleAlignment,
                title: const Text('Approval Process'),
                subtitle: const Text(
                    'To register as a driver, you must provide accurate and complete information during the registration process. This includes personal details, vehicle information, and any other required documentation.Your registration is subject to approval by the company. We reserve the right to accept or reject any registration at our discretion. Approval is contingent upon meeting the eligibility criteria and providing accurate information.'),
              ),
              SizedBox(
                height: 12.0,
              ),
              const Divider(height: 0),
              CheckboxListTile(
                value: checkboxValue2,
                onChanged: (bool? value) {
                  setState(() {
                    checkboxValue2 = value!;
                  });
                },
                title: const Text('Do you agree to these conditions?'),
                subtitle: const Text(
                    'These terms and conditions are governed by and construed in accordance with the laws of Texia'),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40.0, horizontal: 12),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        if (checkboxValue2) {
                          submitalldata();
                        }
                      } catch (e) {
                        print('Error in submitalldata: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(200, 40),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      // backgroundColor: Color.fromARGB(255, 5, 73, 128),
                      backgroundColor: (checkboxValue2)
                          ? Color.fromARGB(255, 5, 73, 128)
                          : Color.fromARGB(255, 187, 189, 190),
                    ),
                    child: Text(
                      "Submit Data",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitalldata() async {
    Driver newDriver = Driver(
      driverID: driverID!,
      firstName: widget.firstName,
      lastName: widget.lastName,
      birthday: widget.birthday,
      gender: widget.gender,
      telephone: widget.telephone,
      email: widget.email,
      address: widget.address,
      isVehicleOwner: widget.isVehicleOwner,
      profileImg: widget.faceimg,
      nicFront: widget.nicfont,
      nicBack: widget.nicback,
      licenseFront: widget.drivingfont,
      licenseBack: widget.drivingback,
      whichVehicle: widget.selectvehical,
      vehicleNumber: widget.vehicalnumber,
      brand: widget.band,
      model: widget.model,
      vehicleImg: widget.vehicalimg,
      date: DateTime.now().toString(),
      yourVehicleOnly: widget.onlyMyVehicle,
      points: 0,
    );

    CollectionReference driversCollection =
        FirebaseFirestore.instance.collection('Drivers');
    try {
      await driversCollection
          .doc(driverID)
          .set(newDriver.toMap())
          .then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/driverhome', (route) => false);
      });
      print('Data has been successfully written to Firestore.');

      // after finished registation where should go enter here
    } catch (e) {
      print('Error writing to Firestore: $e');
    }
  }
}
