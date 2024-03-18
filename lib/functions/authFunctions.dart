import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:anti_ragging/screens/splash/splash_page.dart';
import 'package:anti_ragging/screens/widgets/complaint_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static signupUser(String email, String password, String name,
      String department, String phone, BuildContext context) async {
    try {
      print("============================================");
        print(email);
        print(password);
      print(name);
      print(phone);
      print(department);
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);

      await FirestoreServices.saveUser(
          name, email, userCredential.user!.uid, department, phone);
      ComplaintDialog.snackBar(
          context, SnackBarType.success, 'Registration Successful');

      final _sharedPrefs = await SharedPreferences.getInstance();
      await _sharedPrefs.setBool(SAVE_KEY_NAME, true);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ComplaintDialog.snackBar(context, SnackBarType.error,
            'Password is too weak. Please choose a stronger password.');
      } else if (e.code == 'email-already-in-use') {
        ComplaintDialog.snackBar(context, SnackBarType.error,
            'Email already exists. Please use a different email.');
      } else {
        ComplaintDialog.snackBar(
            context, SnackBarType.error, 'Registration failed. ${e.message}');
      }
    } catch (e) {
      ComplaintDialog.snackBar(context, SnackBarType.error,
          'An unexpected error occurred. ${e.toString()}');
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      ComplaintDialog.snackBar(
          context, SnackBarType.success, 'You are Logged in');
      final _sharedPrefs = await SharedPreferences.getInstance();
      await _sharedPrefs.setBool(SAVE_KEY_NAME, true);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        ComplaintDialog.snackBar(
            context, SnackBarType.error, 'Invalid credentials');
      }
    }
  }
}
