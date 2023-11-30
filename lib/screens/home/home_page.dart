import 'package:anti_ragging/screens/auth/login_page.dart';
import 'package:anti_ragging/screens/widgets/anit_ragging_boxes.dart';
import 'package:anti_ragging/screens/widgets/top_boxes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<int> _counter = ValueNotifier(0);
  User? _user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
      if (user == null) {
        _clearPreferences();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                "CampUs",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5E3FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    TopBoxes(
                      totalCases: 10,
                      pendingCases: 3,
                      solvedCases: 8,
                    ),
                    Expanded(
                        child: AntiRaggingBoxes()
                    ),
                    Center(
                      child: ValueListenableBuilder(
                        valueListenable: _counter,
                        builder: (BuildContext ctx, int newVal, Widget? child) {
                          return Text('Counter: $newVal');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _clearPreferences() async {
    final _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();
  }
}
