import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/widgets/appBar.dart';
import 'package:flutter/material.dart';

class Ragging_Details_page extends StatelessWidget {
  final Key? key;
  final String name;
  final String caseNumber;
  final String desc;
  final complaintType;
  final date;
  final time;
  final studentNames;

  Ragging_Details_page(
      {this.key,
      required this.name,
      required this.caseNumber,
      required this.desc,
      required this.complaintType,
      this.date,
      this.studentNames,
      this.time})
      : super(key: key);

  onPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Update"),
          content: Text("Are you sure you want to mark this case as solved?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                updateCaseStatus(int.parse(caseNumber));
                Navigator.pop(context);
                FirestoreServices.getAllComplaints();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          App_Bar(logout: false),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5E3FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Case $caseNumber",
                      style: TextStyle(
                        fontSize: 30.0, // Set the desired text size
                        fontWeight:
                            FontWeight.bold, // Set the desired font weight
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(complaintType),
                    SizedBox(height: 10.0),
                    Text(
                      "Explanation :",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 18.0, // Set the desired text size
                        fontWeight:
                            FontWeight.normal, // Set the desired font weight
                      ),
                    ),
                    if (studentNames.isNotEmpty) SizedBox(height: 10.0),
                    if (studentNames.isNotEmpty)
                      Text(
                        "Ragging Students Names :",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    Text(" $studentNames"),
                    if (studentNames.isNotEmpty) SizedBox(height: 10.0),
                    Text(
                      "Date and Time :",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text("$date , $time"),
                    SizedBox(height: 10.0),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => onPressed(context),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                          ),
                          child: Text(
                            "SOLVED",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white70),
                          ),
                        ),
                      ),
                    SizedBox(height: 10.0),

                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                          ),
                          child: Text(
                            "GET STUDENT DETAILS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white70),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
