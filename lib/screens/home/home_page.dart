import 'package:anti_ragging/screens/auth/login_page.dart';
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
    // Listen for changes in the authentication state
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
        color: Colors.black, // Set the background color of the entire page
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent, // Make the app bar transparent
              title: Text(
                "CampUs",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // Sign out the current user
                    FirebaseAuth.instance.signOut();
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5E3FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0), // Adjust the radius as needed
                  topRight: Radius.circular(20.0), // Adjust the radius as needed
                ),
              ),
              child: Column(
                children: [
                  _buildTopBoxes(),
                  // Add the rest of your content below the top boxes
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
          ],
        ),
      ),
    );
  }



  Widget _buildTopBoxes() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildTopBox("Total Case", 10),
          ),
          SizedBox(width: 8), // Add spacing between boxes
          Expanded(
            child: _buildTopBox("Pending Case", 3),
          ),
          SizedBox(width: 8), // Add spacing between boxes
          Expanded(
            child: _buildTopBox("Solved Case", 8),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBox(String text, int number) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5), // Darker shadow
            blurRadius: 8, // Increase the blur radius for a stronger shadow
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 13),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 26,
                  fontWeight: FontWeight.w600), // Increase font size
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearPreferences() async {
    final _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();
  }
}
