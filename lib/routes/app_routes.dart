import 'package:flutter/material.dart';
import 'package:taxia/views/home_page/home_page.dart';

class AppRoutes {
  static const String initialRoute = '/';

  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomePage(),
  };
}
