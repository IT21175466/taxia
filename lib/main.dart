import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/country_select_provider.dart';
import 'package:taxia/providers/permission_provider.dart';
import 'package:taxia/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CountrySelectProvider()),
        ChangeNotifierProvider(create: (context) => PermissionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          dividerColor: Colors.transparent,
        ),
        initialRoute: '/permissions',
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
