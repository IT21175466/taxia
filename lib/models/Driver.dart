class Driver {
  late String driverID;
  late String firstName;
  late String lastName;
  late String birthday;
  late String gender;
  late String telephone;
  late String email;
  late String address;
  late bool isVehicleOwner;
  late String profileImg;
  late String nicFront;
  late String nicBack;
  late String licenseFront;
  late String licenseBack;
  late String whichVehicle;
  late String vehicleNumber;
  late String brand;
  late String model;
  late String vehicleImg;

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
    };
  }

  // Create an instance of the model from Firestore data
  factory Driver.fromMap(Map<String, dynamic> map, String driverID) {
    return Driver(
      driverID: driverID,
      firstName: map['firstName'],
      lastName: map['lastName'],
      birthday: map['birthday'],
      gender: map['gender'],
      telephone: map['telephone'],
      email: map['email'],
      address: map['address'],
      isVehicleOwner: map['isVehicleOwner'],
      profileImg: map['profileImg'],
      nicFront: map['nicFront'],
      nicBack: map['nicBack'],
      licenseFront: map['licenseFront'],
      licenseBack: map['licenseBack'],
      whichVehicle: map['whichVehicle'],
      vehicleNumber: map['vehicleNumber'],
      brand: map['brand'],
      model: map['model'],
      vehicleImg: map['vehicleImg'],
    );
  }
}
