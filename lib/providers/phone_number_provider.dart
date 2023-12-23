import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:taxia/views/authentication/otp_verify.dart';

class PhoneNumberProvider extends ChangeNotifier {
  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;
  bool loading = false;

  selectCountry(BuildContext context) async {
    countryCode = await countryPicker.showPicker(context: context);
    notifyListeners();
  }

  verifyPhoneNumber(String phone, BuildContext context) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException ex) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ex.message.toString()),
            ),
          );
          print(ex.message.toString());
          loading = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPVerifyPage(verificationID: verificationId),
            ),
          );
          loading = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        phoneNumber: countryCode!.dialCode + phone,
      );
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
