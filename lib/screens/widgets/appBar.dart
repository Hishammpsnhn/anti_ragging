import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:anti_ragging/screens/home/mentoringDetails.dart';
import 'package:anti_ragging/screens/home/ragging_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App_Bar extends StatelessWidget {
  final bool logout;
  final bool isMentor;
  final bool isCell;

  const App_Bar({
    Key? key,
    required this.logout,
    this.isMentor = false,
    this.isCell = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: isMentor || isCell ? getMenotringCount(currentUser!.uid,isMentor,isCell) : Future.value(0),
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



            if (isMentor == true || isCell == true)
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Route<dynamic>? route;

                      if (isCell == true) {
                        route = MaterialPageRoute(builder: (ctx) => Ragging_reports_Page(isCell: isCell));
                      } else if (isMentor == true) {
                        route = MaterialPageRoute(builder: (ctx) => Mentoring_Report_page());
                      }

                      if (route != null) {
                        Navigator.of(context).push(route);
                      }
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
