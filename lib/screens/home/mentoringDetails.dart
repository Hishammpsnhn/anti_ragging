import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:anti_ragging/screens/widgets/appBar.dart';
import 'package:flutter/material.dart';

class Mentoring_Report_page extends StatefulWidget {
  const Mentoring_Report_page({super.key});

  @override
  State<Mentoring_Report_page> createState() => _Mentoring_Report_pageState();
}

class _Mentoring_Report_pageState extends State<Mentoring_Report_page> {
  List<Map<String, dynamic>> mentoringNotifications = [];

  @override
  void initState() {
    super.initState();
    _fetchMentoringForLoggedInUser(currentUser!.uid);
  }

  Future<void> _fetchMentoringForLoggedInUser(String userId) async {
    List<Map<String, dynamic>> fetchedMentoring =
        await FirestoreServices.getMentoringForLoggedInUser(userId);
    print(fetchedMentoring);
    setState(() {
      mentoringNotifications = fetchedMentoring;
    });
  }

  void showMentoringConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Mentoring'),
          content: Text('Do you want to mark mentoring as done?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // User clicked "Yes"
                markMentoringAsDone(id);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // User clicked "No"
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
  void showMentoringDoneDialog(BuildContext context, ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title:Text('Mentoring'),
          content: Text('Mentoring is Done Successfully',style:TextStyle(color: Colors.green),),
        );
      },
    );
  }
  void markMentoringAsDone(String id) {
    // Implement the logic to mark mentoring as done
    // This could include updating the database or any other necessary steps
    // based on your application's requirements.
    updateMentoringStatus(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            App_Bar(logout: false),
            // Container(
            //
            //   decoration: const BoxDecoration(
            //     color: Color(0xFFF5E3FA),
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(5.0),
            //       topRight: Radius.circular(5.0),
            //     ),
            //   ),
            //   width: double.infinity,
            //   // Make the container take the full width
            //   padding: EdgeInsets.all(8.0),
            //   // color: Color(0xFFF5E3FA),
            //   child: Text(
            //     'Student Details',
            //     style: TextStyle(
            //       fontSize: 22,
            //       fontWeight: FontWeight.w600,
            //
            //     ),
            //   ),
            // ),
            Expanded(
              child: Container(
                padding: EdgeInsets.zero,
                color: Color(0xFFF5E3FA),
                child: ListView.separated(
                  itemBuilder: (ctx, index) {
                    //String complaintType = mentoringNotifications[index]['type'];
                    String studentId =
                        mentoringNotifications[index]['studentId'].toString();
                    String date =
                        mentoringNotifications[index]['date'].toString();
                    String time = mentoringNotifications[index]['scheduleTime']
                        .toString();
                    String department =
                        mentoringNotifications[index]['department'].toString();
                    String name =
                        mentoringNotifications[index]['name'].toString();
                    String id =
                        mentoringNotifications[index]['docId'].toString();
                    bool isDone = mentoringNotifications[index]['isDone'];
                    return ListTile(
                      title: Text("${name} ($department)"),
                      // Add 1 to index
                      subtitle: Text(date),
                      leading: Icon(Icons.person_2_sharp, color: Colors.blue),
                      trailing: Text(time),
                      onTap: () {
                        if(isDone){
                          showMentoringDoneDialog(context);
                        }else{
                          showMentoringConfirmationDialog(context, id);
                        }

                      },
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return Divider();
                  },
                  itemCount: mentoringNotifications.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
