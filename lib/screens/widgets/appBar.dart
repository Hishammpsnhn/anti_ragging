import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App_Bar extends StatelessWidget {
  final bool logout;
  const App_Bar({Key? key, required this.logout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        "CampUs",
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 0.5),
      ),
      actions: [
        if(logout)
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
    );
  }
}
