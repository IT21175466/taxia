import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:taxia/views/driver_Registation/drive_condition.dart';
import 'package:taxia/views/driver_Registation/uploadDocument.dart';

class SelectVehical extends StatefulWidget {
  const SelectVehical({super.key});

  @override
  State<SelectVehical> createState() => _SelectVehicalState();
}

class _SelectVehicalState extends State<SelectVehical> {
  String selectedvehical = '';
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
                      
                            color: selectedvehical == "car" ? Color.fromARGB(255, 246, 244, 244) : null,
                            border: selectedvehical == "car" ? Border.all(color: Colors.blue) : null,
                            borderRadius:selectedvehical == "car" ? BorderRadius.circular(10):null,
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
                      onTap: (){
                       
                        setState(() {
                         selectedvehical = "tuk";
                       });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                      
                            color: selectedvehical == "tuk" ? Color.fromARGB(255, 246, 244, 244) : null,
                            border: selectedvehical == "tuk" ? Border.all(color: Colors.blue) : null,
                            borderRadius:selectedvehical == "tuk" ? BorderRadius.circular(10):null,
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
                      onTap: (){
                        setState(() {
                         selectedvehical = "bike";
                       });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                      
                            color: selectedvehical == "bike" ? Color.fromARGB(255, 246, 244, 244) : null,
                            border: selectedvehical == "bike" ? Border.all(color: Colors.blue) : null,
                            borderRadius:selectedvehical == "bike" ? BorderRadius.circular(10):null,
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
                              child: Image.asset('assets/images/bikeSelect.png'),
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
                      
                            color: selectedvehical == "van" ? Color.fromARGB(255, 246, 244, 244) : null,
                            border: selectedvehical == "van" ? Border.all(color: Colors.blue) : null,
                            borderRadius:selectedvehical == "van" ? BorderRadius.circular(10):null,
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
                      onTap: (){
                       
                        setState(() {
                         selectedvehical = "truck";
                       });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                      
                            color: selectedvehical == "truck" ? Color.fromARGB(255, 246, 244, 244) : null,
                            border: selectedvehical == "truck" ? Border.all(color: Colors.blue) : null,
                            borderRadius:selectedvehical == "truck" ? BorderRadius.circular(10):null,
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
                  Expanded(child: Text(""),),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ), // Use OutlineInputBorder for a full border
                    labelText: 'Vehical Number',
                    contentPadding:const EdgeInsets.fromLTRB(15, 1, 1,1),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ), // Use OutlineInputBorder for a full border
                    labelText: 'Brand',
                    contentPadding:const EdgeInsets.fromLTRB(15, 1, 1,1),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ), // Use OutlineInputBorder for a full border
                    labelText: 'Model',
                    contentPadding:const EdgeInsets.fromLTRB(15, 1, 1,1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    // showImagePickerOption(context);
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
                        child:Text('Tap to select your vehicle image.'),
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
