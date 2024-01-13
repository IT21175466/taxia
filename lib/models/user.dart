class User {
  final String userID;
  final String firstName;
  final String lastName;
  final String email;
  final String province;
  final String district;
  final String phoneNum;

  User({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.province,
    required this.district,
    required this.phoneNum,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['UserID'].toString(),
      firstName: json['FirstName'].toString(),
      lastName: json['LastName'].toString(),
      email: json['Email'].toString(),
      province: json['Province'].toString(),
      district: json['District'].toString(),
      phoneNum: json['PhoneNumber'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Province': province,
      'District': district,
      'PhoneNumber': phoneNum,
    };
  }
}
