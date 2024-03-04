class Driver {
  final String driverID;
  final String firstName;
  final String lastName;
  final String birthday;
  final String gender;
  final String telephone;
  final String email;
  final String address;
  final bool isVehicleOwner;
  final String profileImg;
  final String nicFront;
  final String nicBack;
  final String licenseFront;
  final String licenseBack;
  final String whichVehicle;
  final String vehicleNumber;
  final String brand;
  final String model;
  final String vehicleImg;
  final bool yourVehicleOnly;
  final String date;
  final double points;

  // Constructor
  Driver({
    required this.driverID,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.telephone,
    required this.email,
    required this.address,
    required this.isVehicleOwner,
    required this.profileImg,
    required this.nicFront,
    required this.nicBack,
    required this.licenseFront,
    required this.licenseBack,
    required this.whichVehicle,
    required this.vehicleNumber,
    required this.brand,
    required this.model,
    required this.vehicleImg,
    required this.yourVehicleOnly,
    required this.date,
    required this.points,
  });

  // Convert the object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'driverID': driverID,
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday,
      'gender': gender,
      'telephone': telephone,
      'email': email,
      'address': address,
      'isVehicleOwner': isVehicleOwner,
      'profileImg': profileImg,
      'nicFront': nicFront,
      'nicBack': nicBack,
      'licenseFront': licenseFront,
      'licenseBack': licenseBack,
      'whichVehicle': whichVehicle,
      'vehicleNumber': vehicleNumber,
      'brand': brand,
      'model': model,
      'vehicleImg': vehicleImg,
      'yourVehicleOnly': yourVehicleOnly,
      'registed_date': date,
      'Points': points,
    };
  }

  // Create an instance of the model from Firestore data
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverID: json['driverID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthday: json['birthday'],
      gender: json['gender'],
      telephone: json['telephone'],
      email: json['email'],
      address: json['address'],
      isVehicleOwner: json['isVehicleOwner'],
      profileImg: json['profileImg'],
      nicFront: json['nicFront'],
      nicBack: json['nicBack'],
      licenseFront: json['licenseFront'],
      licenseBack: json['licenseBack'],
      whichVehicle: json['whichVehicle'],
      vehicleNumber: json['vehicleNumber'],
      brand: json['brand'],
      model: json['model'],
      vehicleImg: json['vehicleImg'],
      yourVehicleOnly: json['yourVehicleOnly'],
      date: json['registed_date'].toString(),
      points: double.parse(json['Points'].toString()),
    );
  }
}
