import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:anti_ragging/screens/home/mentoringDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App_Bar extends StatelessWidget {
  final bool logout;
  final bool isMentor;

  const App_Bar({
    Key? key,
    required this.logout,
    this.isMentor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: isMentor ? getMenotringCount(currentUser!.uid) : Future.value(0),
      builder: (context, snapshot) {
        int notificationCount = snapshot.data ?? 0;

        return AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "CampUs",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          actions: [
            if (logout)
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            if (isMentor)
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => Mentoring_Report_page()),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 8,
                        child: Text(
                          notificationCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
