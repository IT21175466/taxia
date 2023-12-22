import 'package:flutter/material.dart';

class UserTypeProvider extends ChangeNotifier {
  bool isDriver = false;
  bool isPassenger = false;

  changeUserType() {
    if (isDriver == true) {
      print('Navigate to Driver Sign up');
      //Navigate to Driver Sign up
      notifyListeners();
    } else if (isPassenger == true) {
      print('Navigate to passenger');
      //Navigate to passenger
      notifyListeners();
    }
  }
}
