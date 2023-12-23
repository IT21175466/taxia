import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPProvider extends ChangeNotifier {
  bool loading = false;

  getOTPCode(String vID, String otp, BuildContext context) async {
    try {
      PhoneAuthCredential credential =
          await PhoneAuthProvider.credential(verificationId: vID, smsCode: otp);

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('logedIn', true);
      notifyListeners();

      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        Navigator.pushNamed(context, '/signup');
      });
      loading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      loading = false;
      notifyListeners();
    }
    notifyListeners();
  }
}
