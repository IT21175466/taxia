import 'package:flutter/material.dart';

class UserTypeProvider extends ChangeNotifier {
  bool isDriver = false;
  bool isPassenger = false;

  changeUserType(BuildContext context) {
    if (isDriver == true) {
      print('Navigate to Driver Sign up');
      Navigator.pushNamed(context, '/driverregistation');

      //Navigate to Driver Sign up
      notifyListeners();
    } else if (isPassenger == true) {
      print('Navigate to passenger');
      Navigator.pushNamed(context, '/signup');
      //Navigate to passenger
      notifyListeners();
    }
  }
}
