import 'package:anti_ragging/functions/firebase_api.dart';
import 'package:anti_ragging/screens/home/report_complaint_form%20.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:anti_ragging/screens/auth/login_page.dart';
import 'package:anti_ragging/screens/auth/register_page.dart';
import 'package:anti_ragging/screens/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseService firebaseService = FirebaseService();
  await firebaseService.initializeFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/ComplaintForm': (context) => ComplaintForm(),
        // '/RaggingRule': (context) => RaggingRuleScreen(),
        // '/somethingfunction': (context) => SomethingFunctionScreen(),

        // Add more routes as needed
      },
    );
  }
}
