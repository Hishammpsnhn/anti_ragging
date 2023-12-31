import 'dart:ffi';
import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/auth/login_page.dart';
import 'package:anti_ragging/screens/widgets/anit_ragging_boxes.dart';
import 'package:anti_ragging/screens/widgets/anti_raggint_helpline.dart';
import 'package:anti_ragging/screens/widgets/appBar.dart';
import 'package:anti_ragging/screens/widgets/top_boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/physics.dart';
import 'package:shared_preferences/shared_preferences.dart';

User? currentUser;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ValueNotifier<int> _counter = ValueNotifier(0);
  User? _user;
  bool? _isAdmin;

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
       // updateComplaintsCount();
        await fetchUserDetailsFromFirestore(user.uid);
      }
    });
  }

  Future<void> fetchUserDetailsFromFirestore(String userId) async {
    try {
      // Assuming 'users' is the collection in Firestore where user details are stored
      currentUser = FirebaseAuth.instance.currentUser;
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
  int totalCases = 0;
  int pendingCases = 0;
  @override
  Widget build(BuildContext context) {
    //print(_user);
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            App_Bar(logout: true),
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
                      // Use FutureBuilder to handle the asynchronous operation
                      FutureBuilder<List<int>>(
                        future: Future.wait([getTotalCases(), getPendingCasesCount()]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            totalCases = snapshot.data?[0] ?? 0;
                            pendingCases = snapshot.data?[1] ?? 0;

                            // snapshot.data is a List<int> containing totalCases and pendingCases
                            return TopBoxes(
                              totalCases: totalCases,
                              pendingCases: pendingCases,
                              solvedCases: totalCases - pendingCases,
                            );
                          }
                        },
                      ),
                      AntiRaggingBoxes(isAdmin: _isAdmin),
                      AntiRaggingHelpline(),
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

//   void updateComplaintsCount() async {
//     setState(() {
//       // This is where you might want to trigger some asynchronous operation
//       // to update the complaints list or any other data in your home page.
//       // You can call the methods like getTotalCases(), getPendingCasesCount()
//       // or any other logic you have to refresh your data.
//
//       // For example, if you want to refresh the total and pending cases:
//       Future.wait([getTotalCases(), getPendingCasesCount()]).then((result) {
//         setState(() {
//           totalCases = result[0];
//           pendingCases = result[1];
//         });
//       });
//
//       // If you have other data to update, you can add similar logic here.
//     });
//   }
 }
