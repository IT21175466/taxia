import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/country_select_provider.dart';
import 'package:taxia/providers/permission_provider.dart';
import 'package:taxia/routes/app_routes.dart';
import 'package:taxia/providers/user_type_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showPermission = prefs.getBool('showPermission') ?? false;

  runApp(MyApp(showPermission: showPermission));
}

class MyApp extends StatelessWidget {
  final bool showPermission;
  const MyApp({super.key, required this.showPermission});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CountrySelectProvider()),
        ChangeNotifierProvider(create: (context) => PermissionProvider()),
        ChangeNotifierProvider(create: (context) => UserTypeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          dividerColor: Colors.transparent,
        ),
        initialRoute: showPermission ? '/login' : '/permissions',
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
