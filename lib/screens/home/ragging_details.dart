import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:anti_ragging/screens/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Ragging_Details_page extends StatefulWidget {
  final Key? key;
  final String caseNumber;
  final String desc;
  final complaintType;
  final date;
  final time;
  final solved;
  final studentId;
  final underCell;
  final location;

  Ragging_Details_page(
      {this.key,
      required this.caseNumber,
      required this.desc,
      required this.complaintType,
      this.date,
      this.location,
      this.underCell,
      required this.updateComplaintsList, // Add this line
      this.solved,
      this.studentId,
      this.time})
      : super(key: key);
  final VoidCallback updateComplaintsList;

  @override
  State<Ragging_Details_page> createState() => _Ragging_Details_pageState();
}

class _Ragging_Details_pageState extends State<Ragging_Details_page> {
  // Add this line
  String studentName = '';

  String department = '';

  String phoneNumber = '';

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
              onPressed: () async {
                await updateCaseStatus(int.parse(widget.caseNumber));
                Navigator.pop(context);
                Navigator.pop(context);
                if (userData?.admin == true) widget.updateComplaintsList();
                if (userData?.cell == true) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully Solved!'),
                    duration: Duration(seconds: 3),
                    // Adjust the duration as needed
                    backgroundColor: Colors.green,
                    // Set your desired background color
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  forwardPress(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Forward "),
          content: Text("Are you sure you send to anti raggin cell?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirestoreServices.updateUserToForward(
                    int.parse(widget.caseNumber));
                Navigator.pop(context);
                Navigator.pop(context);
                if (userData?.admin == true) widget.updateComplaintsList();
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
                      "Case ${widget.caseNumber}",
                      style: const TextStyle(
                        fontSize: 30.0, // Set the desired text size
                        fontWeight:
                            FontWeight.bold, // Set the desired font weight
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(widget.complaintType),
                    SizedBox(height: 10.0),
                    const Text(
                      "Explanation :",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.desc,
                      style: const TextStyle(
                        fontSize: 18.0, // Set the desired text size
                        fontWeight:
                            FontWeight.normal, // Set the desired font weight
                      ),
                    ),
                    if (widget.location.isNotEmpty) SizedBox(height: 10.0),
                    if (widget.location.isNotEmpty)
                      Text(
                        "Location : ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    if (widget.location.isNotEmpty) Text(" ${widget.location}"),
                    if (widget.location.isNotEmpty) SizedBox(height: 10.0),
                    const Text(
                      "Date and Time :",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text("${widget.date} , ${widget.time}"),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Case Status :",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.solved
                          ? "Solved"
                          : (widget.underCell
                              ? "Under Anti-Ragging Cell"
                              : "Pending"),
                    ),
                    const SizedBox(height: 10.0),
                    if (!widget.underCell && !widget.solved)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              //opacity: widget.complaintType != 'Ragging' ? 0.5 : 1.0, // Adjust the opacity value as needed
                              child: ElevatedButton(
                                onPressed: widget.complaintType != 'Ragging'
                                    ? null
                                    : () => forwardPress(context),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Border radius
                                  ),
                                ),
                                child: const Text(
                                  "FORWARD",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 16),
                          // Add some spacing between the buttons
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () => onPressed(context),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Border radius
                                  ),
                                ),
                                child: const Text(
                                  "SOLVED ?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (!widget.solved && widget.underCell)
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
                          child: const Text(
                            "SOLVED ?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await getStudentDetails();
                        },
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
                    SizedBox(height: 10.0),
                    if (studentName.isNotEmpty)
                      Text(
                        'Student Name: $studentName',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (department.isNotEmpty)
                      Text(
                        'Department: $department',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (phoneNumber.isNotEmpty)
                      Text(
                        'Phone Number: $phoneNumber',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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

  Future<void> getStudentDetails() async {
    Map<String, dynamic> studentData =
        await FirestoreServices.getStudentById(widget.studentId);
    setState(() {
      studentName = studentData['name'] ?? '';
      department = studentData['department'] ?? '';
      phoneNumber = studentData['phoneNumber'] ?? '';
    });
  }
}
