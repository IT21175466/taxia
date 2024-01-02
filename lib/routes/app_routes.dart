import 'package:flutter/material.dart';
import 'package:taxia/views/authentication/login_page.dart';
import 'package:taxia/views/authentication/phone_validation_page.dart';
import 'package:taxia/views/authentication/signup_page.dart';
import 'package:taxia/views/authentication/type_selection.dart';
import 'package:taxia/views/driver_registation/regform.dart';
import 'package:taxia/views/home_screen/home_page.dart';
import 'package:taxia/views/map/map_page.dart';
import 'package:taxia/views/permissions/permission_page.dart';
import 'package:taxia/views/splash_screen/initial_splash.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/permissions': (context) => PermissionsPage(),
      '/login': (context) => LoginPage(),
      '/signup': (context) => SignUpPage(),
      '/typeselection': (context) => UserTypeSelection(),
      '/phonevalidation': (context) => PhoneValidation(),
      '/home': (context) => HomePage(),
      '/map': (context) => MapPage(),
      '/driverregistation': (context) => DriveRegistation(),
      '/initsplash': (context) => InitialSplash(),
    };
  }
}
