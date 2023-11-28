import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    });
  }

  void increment() {
    _counter.value = _counter.value + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              // Sign out the current user
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: _counter,
              builder: (BuildContext ctx, int newVal, Widget? child) {
                return Text('Counter: $newVal');
              },
            ),
            SizedBox(height: 16),
            _user != null
                ? Column(
              children: [
                Text('User ID: ${_user!.uid}'),
                SizedBox(height: 8),
                Text('Email: ${_user!.email}'),
                SizedBox(height: 8),
                Text('Display Name: ${_user!.displayName ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('Photo URL: ${_user!.photoURL ?? 'N/A'}'),
              ],
            )
                : Text('No user is currently logged in.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          increment();
        },
      ),
    );
  }
}
