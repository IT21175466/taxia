import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxia/views/driver_registation/drive_condition.dart';

class SelectVehical extends StatefulWidget {
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

  const SelectVehical({
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
  });

  @override
  State<SelectVehical> createState() => _SelectVehicalState();
}

class _SelectVehicalState extends State<SelectVehical> {
  //final ImagePicker _picker = ImagePicker();

  File? _vehicalimage;

  String selectedvehical = '';
  String downloadUrl = "";
  String vehicalimg = '';

  TextEditingController vehicalnumberController = TextEditingController();
  TextEditingController bandController = TextEditingController();
  TextEditingController modelController = TextEditingController();

  Future<void> uploadImage(File imageFile, String type) async {
    try {
      String fileExtension = imageFile.path.split('.').last;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      fileName = '$fileName.$fileExtension';

      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        // Image uploaded successfully, get the download URL
        downloadUrl = await storageReference.getDownloadURL();
        print('Image uploaded. Download URL: $downloadUrl');
        switch (type) {
          case "vehicalimg":
            vehicalimg = downloadUrl;
            break;
        }
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

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
                  "Select Your vehical",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedvehical = "car";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedvehical == "car"
                              ? Color.fromARGB(255, 246, 244, 244)
                              : null,
                          border: selectedvehical == "car"
                              ? Border.all(color: Colors.blue)
                              : null,
                          borderRadius: selectedvehical == "car"
                              ? BorderRadius.circular(10)
                              : null,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Car',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Image.asset('assets/images/car.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedvehical = "tuk";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedvehical == "tuk"
                              ? Color.fromARGB(255, 246, 244, 244)
                              : null,
                          border: selectedvehical == "tuk"
                              ? Border.all(color: Colors.blue)
                              : null,
                          borderRadius: selectedvehical == "tuk"
                              ? BorderRadius.circular(10)
                              : null,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Tuk',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Image.asset('assets/images/tuk.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedvehical = "bike";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedvehical == "bike"
                              ? Color.fromARGB(255, 246, 244, 244)
                              : null,
                          border: selectedvehical == "bike"
                              ? Border.all(color: Colors.blue)
                              : null,
                          borderRadius: selectedvehical == "bike"
                              ? BorderRadius.circular(10)
                              : null,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bike',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child:
                                  Image.asset('assets/images/bikeSelect.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedvehical = "van";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedvehical == "van"
                              ? Color.fromARGB(255, 246, 244, 244)
                              : null,
                          border: selectedvehical == "van"
                              ? Border.all(color: Colors.blue)
                              : null,
                          borderRadius: selectedvehical == "van"
                              ? BorderRadius.circular(10)
                              : null,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'van',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Image.asset('assets/images/van.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedvehical = "truck";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedvehical == "truck"
                              ? Color.fromARGB(255, 246, 244, 244)
                              : null,
                          border: selectedvehical == "truck"
                              ? Border.all(color: Colors.blue)
                              : null,
                          borderRadius: selectedvehical == "truck"
                              ? BorderRadius.circular(10)
                              : null,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Truck',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Image.asset('assets/images/truck.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(""),
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              const Divider(height: 0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Vehical Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: TextFormField(
                  controller: vehicalnumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ), // Use OutlineInputBorder for a full border
                    labelText: 'Vehical Number',
                    contentPadding: const EdgeInsets.fromLTRB(15, 1, 1, 1),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: TextFormField(
                  controller: bandController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ), // Use OutlineInputBorder for a full border
                    labelText: 'Brand',
                    contentPadding: const EdgeInsets.fromLTRB(15, 1, 1, 1),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: TextFormField(
                  controller: modelController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ), // Use OutlineInputBorder for a full border
                    labelText: 'Model',
                    contentPadding: const EdgeInsets.fromLTRB(15, 1, 1, 1),
                  ),
                ),
              ),
              buildImageWidget(_vehicalimage,
                  'Tap to select an NIC font side image', 'vehicalimg'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40.0, horizontal: 12),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Gotocondition();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(200, 40),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Color.fromARGB(255, 5, 73, 128),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255)),
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

  Widget buildImageWidget(File? image, String description, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                context: context,
                builder: (builder) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 8,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final returnImage =
                                    await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (returnImage == null) return;
                                setState(() {
                                  uploadImage(File(returnImage.path), type);
                                  switch (type) {
                                    case "vehicalimg":
                                      _vehicalimage = File(returnImage.path);
                                      break;
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                              child: const SizedBox(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 70,
                                    ),
                                    Text("Gallery"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final returnImage =
                                    await ImagePicker().pickImage(
                                  source: ImageSource.camera,
                                );
                                if (returnImage == null) return;
                                setState(() {
                                  uploadImage(File(returnImage.path), type);
                                  switch (type) {
                                    case "vehicalimg":
                                      _vehicalimage = File(returnImage.path);
                                      break;
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                              child: const SizedBox(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 70,
                                    ),
                                    Text("Camera"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).then((_) {
                // Handle modal pop
                setState(() {});
              });
            },
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(10.0),
              padding: EdgeInsets.all(6),
              color: Colors.black,
              strokeWidth: 0.8,
              child: Container(
                height: 100.0,
                child: Center(
                  child: image != null
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.file(
                                  image,
                                  width: 100.0,
                                  height: 100.0,
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              left: 10,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    switch (type) {
                                      case "vehicalimg":
                                        _vehicalimage = null;
                                        break;
                                    }
                                    print("close btn click");
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(111, 244, 67, 54),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    "Close",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(description),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void Gotocondition() {
    String vehicalnumber = vehicalnumberController.text;
    String modal = modelController.text;
    String band = bandController.text;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Teamandcondition(
                firstName: widget.firstName,
                lastName: widget.lastName,
                birthday: widget.birthday,
                gender: widget.gender,
                telephone: widget.telephone,
                email: widget.email,
                address: widget.address,
                isVehicleOwner: widget.isVehicleOwner,
                faceimg: widget.faceimg,
                nicfont: widget.nicfont,
                nicback: widget.nicback,
                drivingfont: widget.drivingfont,
                drivingback: widget.drivingback,
                selectvehical: selectedvehical,
                band: band,
                model: modal,
                vehicalnumber: vehicalnumber,
                vehicalimg: vehicalimg,
              )), // Replace UploadScreen() with your desired destination screen
    );
  }
}
