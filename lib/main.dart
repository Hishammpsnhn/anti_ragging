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
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
