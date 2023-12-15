import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/ragging_details.dart';
import 'package:anti_ragging/screens/widgets/appBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ragging_reports_Page extends StatefulWidget {
  const Ragging_reports_Page({Key? key}) : super(key: key);

  @override
  _Ragging_report_PageState createState() => _Ragging_report_PageState();
}

class _Ragging_report_PageState extends State<Ragging_reports_Page> {
  List<Map<String, dynamic>> complaints = [];

  @override
  void initState() {
    super.initState();
    getAllComplaints();
  }

  Future<void> getAllComplaints() async {
    List<Map<String, dynamic>> fetchedComplaints =
    await FirestoreServices.getAllComplaints();
    setState(() {
      complaints = fetchedComplaints;
    });

  }


  // Function to get icon based on complaint type
  Icon getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'ragging':
        return Icon(Icons.policy, color: Colors.red);
      case 'maintenance':
        return Icon(Icons.build, color: Colors.orange);
      default:
        return Icon(Icons.book, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            App_Bar(logout: false),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5E3FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                ),
                child: ListView.separated(
                  itemBuilder: (ctx, index) {
                    String complaintType = complaints[index]['type'];
                    String caseNumber = complaints[index]['caseNumber'].toString();
                    String desc = complaints[index]['explanation'].toString();
                    print(caseNumber);
                    return ListTile(
                      title: Text("Case: ${caseNumber}"),
                      // Add 1 to index
                      subtitle: Text("Type: $complaintType"),
                      leading: getIconForType(complaintType),
                      //trailing: Text("${complaints[index]['time']}"),
                      trailing: Icon(
                        complaints[index]['solved'] ? Icons.check : Icons.close,
                        color: complaints[index]['solved'] ? Colors.green : Colors.red,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return Ragging_Details_page(
                                name: complaints[index]['studentNames'],
                                caseNumber:caseNumber,
                                desc: desc,
                                complaintType:complaintType,
                                date:complaints[index]['date'],
                                time:complaints[index]['time'],
                                studentNames:complaints[index]['studentNames'],

                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return Divider();
                  },
                  itemCount: complaints.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
