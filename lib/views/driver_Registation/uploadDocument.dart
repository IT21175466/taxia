import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxia/views/driver_Registation/selectvehical.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadDument extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String birthday;
  final String gender;
  final String telephone;
  final String email;
  final String address;
  final bool isVehicleOwner;

  UploadDument({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.telephone,
    required this.email,
    required this.address,
    required this.isVehicleOwner,
  });

  @override
  State<UploadDument> createState() => _UploadDumentState();
}

class _UploadDumentState extends State<UploadDument> {
  final ImagePicker _picker = ImagePicker();

  File? _faceimage;
  File? _nicfrontimage;
  File? _nicbackimage;
  File? _drivingfontimage;
  File? _drivingbackimage;

  String faceUrl = '';
  String nicfront = '';
  String nicback = '';
  String drivingfont = '';
  String drivingback = '';

  String downloadUrl = '';

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
          case "face":
            faceUrl = downloadUrl;

            break;
          case "nicfont":
            nicfront = downloadUrl;

            break;
          case "nicback":
            nicback = downloadUrl;

            break;
          case "Drivingfont":
            drivingfont = downloadUrl;

            break;
          case "Drivingback":
            drivingback = downloadUrl;

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
                  "Upload Documents",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                child: Text(
                  "Your image",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              buildImageWidget(_faceimage, 'Tap to select an image', 'face'),
              SizedBox(
                height: 12.0,
              ),
              const Divider(height: 0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                child: Text(
                  "NIC image",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              // Tap to select an image
              buildImageWidget(_nicfrontimage,
                  'Tap to select an NIC font side image', 'nicfont'),
              buildImageWidget(_nicbackimage,
                  'Tap to select an NIC font side image', 'nicback'),

              SizedBox(
                height: 12.0,
              ),
              const Divider(height: 0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                child: Text(
                  "Driving License Image",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              buildImageWidget(
                  _drivingfontimage,
                  'Tap to select an Driving License font side image',
                  'Drivingfont'),
              buildImageWidget(
                  _drivingbackimage,
                  'Tap to select an Driving License back side image',
                  'Drivingback'),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40.0, horizontal: 12),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectVehical(
                                  firstName: widget.firstName,
                                  lastName: widget.lastName,
                                  birthday: widget.birthday,
                                  gender: widget.gender,
                                  telephone: widget.telephone,
                                  email: widget.email,
                                  address: widget.address,
                                  isVehicleOwner: widget.isVehicleOwner,
                                  faceimg: faceUrl,
                                  nicfont: nicfront,
                                  nicback: nicback,
                                  drivingfont: drivingfont,
                                  drivingback: drivingback,
                                )), // Replace UploadScreen() with your desired destination screen
                      );
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
                                    case "face":
                                      _faceimage = File(returnImage.path);

                                      break;
                                    case "nicfont":
                                      _nicfrontimage = File(returnImage.path);

                                      break;
                                    case "nicback":
                                      _nicbackimage = File(returnImage.path);

                                      break;
                                    case "Drivingfont":
                                      _drivingfontimage =
                                          File(returnImage.path);

                                      break;
                                    case "Drivingback":
                                      _drivingbackimage =
                                          File(returnImage.path);

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
                                    case "face":
                                      _faceimage = File(returnImage.path);

                                      break;
                                    case "nicfont":
                                      _nicfrontimage = File(returnImage.path);

                                      break;
                                    case "nicback":
                                      _nicbackimage = File(returnImage.path);

                                      break;
                                    case "Drivingfont":
                                      _drivingfontimage =
                                          File(returnImage.path);

                                      break;
                                    case "Drivingback":
                                      _drivingbackimage =
                                          File(returnImage.path);

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
                                      case "face":
                                        _faceimage = null;
                                        break;
                                      case "nicfont":
                                        _nicfrontimage = null;
                                        break;
                                      case "nicback":
                                        _nicbackimage = null;
                                        break;
                                      case "Drivingfont":
                                        _drivingfontimage = null;
                                        break;
                                      case "Drivingback":
                                        _drivingbackimage = null;
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
  
}
