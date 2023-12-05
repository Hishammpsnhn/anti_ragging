import 'dart:ffi';

import 'package:anti_ragging/screens/auth/login_page.dart';
import 'package:anti_ragging/screens/widgets/anit_ragging_boxes.dart';
import 'package:anti_ragging/screens/widgets/top_boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/physics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<int> _counter = ValueNotifier(0);
  User? _user;
  bool? _isAdmin; // Add a variable to store the user name, for example

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      setState(() {
        _user = user;
      });

      if (user == null) {
        _clearPreferences();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Fetch additional user details from Firestore
        await fetchUserDetailsFromFirestore(user.uid);
      }
    });
  }

  Future<void> fetchUserDetailsFromFirestore(String userId) async {
    try {
      // Assuming 'users' is the collection in Firestore where user details are stored
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        print(userData);
        bool isAdmin = userData['admin'] ?? false;

        setState(() {
          _isAdmin = isAdmin;
        });
      } else {
        print('User document does not exist in Firestore');
      }
    } catch (error) {
      print('Error fetching user details from Firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(_user);
    return Scaffold(
      body: Container(
        color: Colors.black45,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TopBoxes(
                        totalCases: 10,
                        pendingCases: 3,
                        solvedCases: 8,
                      ),
                      AntiRaggingBoxes(isAdmin: _isAdmin),
                    ],
                  ),
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
