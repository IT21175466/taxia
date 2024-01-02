import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/firebase_options.dart';
import 'package:taxia/providers/home/bootom_nav_bar_provider.dart';
import 'package:taxia/providers/map/map_provider.dart';
import 'package:taxia/providers/auth/otp_provider.dart';
import 'package:taxia/providers/auth/phone_number_provider.dart';
import 'package:taxia/providers/auth/permission_provider.dart';
import 'package:taxia/providers/ride/ride_provider.dart';
import 'package:taxia/providers/user/login_provider.dart';
import 'package:taxia/providers/user/user_provider.dart';
import 'package:taxia/routes/app_routes.dart';
import 'package:taxia/providers/auth/user_type_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final showPermission = prefs.getBool('showPermission') ?? false;
  final loginStatus = prefs.getBool('logedIn') ?? false;

  runApp(MyApp(showPermission: showPermission, loginStatus: loginStatus));
}

class MyApp extends StatelessWidget {
  final bool showPermission;
  final bool loginStatus;
  const MyApp(
      {super.key, required this.showPermission, required this.loginStatus});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PhoneNumberProvider()),
        ChangeNotifierProvider(create: (context) => PermissionProvider()),
        ChangeNotifierProvider(create: (context) => UserTypeProvider()),
        ChangeNotifierProvider(create: (context) => OTPProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavBarProvider()),
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => RideProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          dividerColor: Colors.transparent,
        ),

        initialRoute: (showPermission && loginStatus)
            ? '/initsplash'
            : (showPermission ? '/login' : '/permissions'),
        //initialRoute: '/driverregistation',
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
