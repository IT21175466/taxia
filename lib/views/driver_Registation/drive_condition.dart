import 'package:flutter/material.dart';

class Teamandcondition extends StatefulWidget {
  const Teamandcondition({super.key});

  @override
  State<Teamandcondition> createState() => _TeamandconditionState();
}

class _TeamandconditionState extends State<Teamandcondition> {
  ListTileTitleAlignment? titleAlignment;
  bool checkboxValue2= false;
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Teamandcondition()), // Replace UploadScreen() with your desired destination screen
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
}
