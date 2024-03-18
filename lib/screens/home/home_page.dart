import 'dart:ffi';

import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/auth/login_page.dart';
import 'package:anti_ragging/screens/widgets/anit_ragging_boxes.dart';
import 'package:anti_ragging/screens/widgets/anti_raggint_helpline.dart';
import 'package:anti_ragging/screens/widgets/appBar.dart';
import 'package:anti_ragging/screens/widgets/mentorTimeSchedule.dart';
import 'package:anti_ragging/screens/widgets/top_boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/physics.dart';
import 'package:shared_preferences/shared_preferences.dart';

User? currentUser;
UserDataModel? userData; // Declare userData as nullable
bool? _isAdmin;

class UserDataModel {
  String fromTime;
  bool cell;
  bool main;
  bool admin;
  String toTime;
  int noOfAppointment;

  UserDataModel(
      {required this.fromTime,
      required this.toTime,
      required this.admin,
      required this.noOfAppointment,
      required this.cell,
      required this.main});
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<int> _counter = ValueNotifier(0);
  User? _user;

  bool _isMentor = false;
  bool _cell = false;
  bool _main = false;

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
        print(user);
        await fetchUserDetailsFromFirestore(user.uid);
      }
    });
  }

  Future<void> fetchUserDetailsFromFirestore(String userId) async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userMap =
            userSnapshot.data() as Map<String, dynamic>;
        print("$userMap");

        if (userData != null) {
          userData!.fromTime = userMap['fromTime'] ?? '';
          userData!.toTime = userMap['toTime'] ?? '';
        } else {
          // If userData is null, create a new instance
          userData = UserDataModel(
              noOfAppointment: userMap['numberOfSchedules'] ?? 0,
              fromTime: userMap['fromTime'] ?? '',
              toTime: userMap['toTime'] ?? '',
              cell: userMap['cell'] ?? false,
              main: userMap['main'] ?? false,
              admin:userMap['admin'] ?? false);
        }

        bool isAdmin = userMap['admin'] ?? false;
        bool isMentor = userMap['mentor'] ?? false;
        bool isCell = userMap['cell'] ?? false;
        bool main = userMap['main'] ?? false;
        setState(() {
          _isMentor = isMentor;
        });
        setState(() {
          _cell = isCell;
        });
        setState(() {
          _main = main;
        });

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
            App_Bar(logout: true, isMentor: _isMentor, isCell: _cell),
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
                        future: Future.wait(
                            [getTotalCases(), getPendingCasesCount()]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                      AntiRaggingBoxes(isAdmin: _isAdmin,isCell: _cell,main:_main),
                      if (_isMentor) MentorTimeSchedule(),
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
