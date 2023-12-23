import 'package:flutter/material.dart';
import 'package:taxia/views/authentication/login_page.dart';
import 'package:taxia/views/permissions/permission_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/permissions': (context) => PermissionsPage(),
      '/login': (context) => LoginPage(),
    };
  }
}
