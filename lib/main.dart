import 'package:anti_ragging/screens/auth/login_page.dart';
import 'package:anti_ragging/screens/auth/register_page.dart';
import 'package:anti_ragging/screens/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  // await Firebase.initializeApp();
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //       options: FirebaseOptions(
  //           apiKey: "AIzaSyCP-g8l2uVD97dM1uzRb3JO8EGSo5DclvQ",
  //           appId: "1:752383861914:web:880d74bcfacb1cb5532b23",
  //           messagingSenderId: "752383861914",
  //           projectId: "antiragging-27f01"));
  // }else{
  //     await Firebase.initializeApp();
  // }
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.deepOrange),
      home: SplashPage(),
    );
  }
}
