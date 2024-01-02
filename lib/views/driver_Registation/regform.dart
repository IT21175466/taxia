import 'package:flutter/material.dart';
import 'package:taxia/views/driver_registation/uploadDocument.dart';

class DriveRegistation extends StatefulWidget {
  const DriveRegistation({super.key});

  @override
  State<DriveRegistation> createState() => _DriveRegistationState();
}

class _DriveRegistationState extends State<DriveRegistation> {
  String? selectedGender;
  bool checkboxValue2 = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController brithdayController = TextEditingController();
  TextEditingController gendereController = TextEditingController();
  TextEditingController teleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController vehicalownerController = TextEditingController();

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
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Text(
              //     "Private Information",
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //   ),
              // ),
              Center(
                child: ClipOval(
                  child: Container(
                    color: Color.fromARGB(117, 233, 233, 233),
                    child: Image.asset(
                      'assets/images/driverElement.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                child: Text(
                  "About You",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 1, 1, 1),
                                labelText: 'First Name',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius as needed
                                ), // Use OutlineInputBorder for a full border
                                labelText: 'Last Name',
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 1, 1, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        controller: brithdayController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 1, 1, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ), // Use OutlineInputBorder for a full border
                          labelText: 'Brithday',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 1, 1, 1),
                        ),

                        value: selectedGender,
                        onChanged: (String? newValue) {
                          // Handle dropdown value change here
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                        items: ['Male', 'Female']
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        hint: Text('Select gender'), // Optional hint text
                      ),
                    )
                  ],
                ),
              ),
              const Divider(height: 0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18),
                child: Text(
                  "Contact Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: TextFormField(
                  controller: teleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ), // Use OutlineInputBorder for a full border
                    labelText: 'Telephone Number',
                    contentPadding: const EdgeInsets.fromLTRB(15, 1, 1, 1),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ), // Use OutlineInputBorder for a full border
                    labelText: 'Email',
                    contentPadding: const EdgeInsets.fromLTRB(15, 1, 1, 1),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ), // Use OutlineInputBorder for a full border
                    labelText: 'Address',
                    contentPadding: const EdgeInsets.fromLTRB(15, 1, 1, 1),
                  ),
                ),
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
                title: const Text('Are you the vehicle owner?'),
                subtitle: const Text(
                    'Check this box if you are the owner of the vehicle.'),
              ),
              const Divider(height: 0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40.0, horizontal: 12),
                child: Center(
                  child: ElevatedButton(
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             UploadDument()), // Replace UploadScreen() with your desired destination screen
                    //   );
                    // },
                    onPressed: () {
                      fristcontinous();
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

  void fristcontinous() {
    String firstName = firstNameController.text;
    String lastname = lastNameController.text;
    String brithday = brithdayController.text;
    String telephone = teleController.text;
    String email = emailController.text;
    String Address = addressController.text;
    bool vhicalowner = checkboxValue2;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadDument(
          firstName: firstName,
          lastName: lastname,
          birthday: brithday,
          gender: selectedGender!,
          telephone: telephone,
          email: email,
          address: Address,
          isVehicleOwner: vhicalowner,
        ),
      ),
    );
  }
}
