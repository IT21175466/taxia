import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxia/views/driver_Registation/selectvehical.dart';

class UploadDument extends StatefulWidget {
  const UploadDument({super.key});

  @override
  State<UploadDument> createState() => _UploadDumentState();
}

class _UploadDumentState extends State<UploadDument> {
  late File _image;
  final ImagePicker _picker = ImagePicker();
  late XFile? faceimg;
  @override
  Widget build(BuildContext context) {
    var ui;
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

              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    showImagePickerOption(context);
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10.0),
                    padding: EdgeInsets.all(6),
                    color: Colors.black, // Adjust the color as needed
                    strokeWidth: 0.8, // Adjust the width of the dotted border
                    child: Container(
                      height: 100.0, // Adjust the height as needed
                      child: Center(
                        // ignore: unnecessary_null_comparison
                        child:Text('Tap to select an image'),
                      ),
                    ),
                  ),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    showImagePickerOption(context);
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10.0),
                    padding: EdgeInsets.all(6),
                    color: Colors.black, // Adjust the color as needed
                    strokeWidth: 0.8, // Adjust the width of the dotted border
                    child: Container(
                      height: 100.0, // Adjust the height as needed
                      child: Center(
                        // ignore: unnecessary_null_comparison
                        child:Text('Tap to select an image'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    showImagePickerOption(context);
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10.0),
                    padding: EdgeInsets.all(6),
                    color: Colors.black, // Adjust the color as needed
                    strokeWidth: 0.8, // Adjust the width of the dotted border
                    child: Container(
                      height: 100.0, // Adjust the height as needed
                      child: Center(
                        // ignore: unnecessary_null_comparison
                        child:Text('Tap to select an image'),
                      ),
                    ),
                  ),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    showImagePickerOption(context);
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10.0),
                    padding: EdgeInsets.all(6),
                    color: Colors.black, // Adjust the color as needed
                    strokeWidth: 0.8, // Adjust the width of the dotted border
                    child: Container(
                      height: 100.0, // Adjust the height as needed
                      child: Center(
                        // ignore: unnecessary_null_comparison
                        child:Text('Tap to select an image'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    showImagePickerOption(context);
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10.0),
                    padding: EdgeInsets.all(6),
                    color: Colors.black, // Adjust the color as needed
                    strokeWidth: 0.8, // Adjust the width of the dotted border
                    child: Container(
                      height: 100.0, // Adjust the height as needed
                      child: Center(
                        // ignore: unnecessary_null_comparison
                        child:Text('Tap to select an image'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40.0, horizontal: 12),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SelectVehical()), // Replace UploadScreen() with your desired destination screen
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

  void showImagePickerOption(BuildContext context) {
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
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      var selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync() as File;
    });
    Navigator.of(context).pop(); //close the model sheet
  }

//Camera
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      var selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync() as File;
    });
    Navigator.of(context).pop();
  }
}
