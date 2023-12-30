import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxia/views/splash_screen/splash_screen.dart';

class OTPProvider extends ChangeNotifier {
  bool loading = false;
  String userId = '';

  getOTPCode(String vID, String otp, BuildContext context) async {
    try {
      PhoneAuthCredential credential =
          await PhoneAuthProvider.credential(verificationId: vID, smsCode: otp);

      FirebaseAuth.instance.signInWithCredential(credential).then(
        (UserCredential userCredential) async {
          userId = userCredential.user!.uid;
          print("User ID: $userId");
          setUserID(userId);

          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('logedIn', true);

          notifyListeners();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(
                id: userId,
              ),
            ),
          );
          loading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      loading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> setUserID(String uID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', uID);
  }
}
