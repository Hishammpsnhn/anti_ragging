import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirestoreServices {
  static saveUser(String name, email, uid, String department, String phone) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'department': department,
      'phoneNumber': phone,
      'admin': false
    });
  }

  static Future<void> saveComplaint(
      String userId,
      String type,
      String date,
      String time,
      String studentNames,
      String explanation,
      BuildContext context,
      ) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference =
      await FirebaseFirestore.instance.collection('complaints').add({
        'studentId': userId,
        'type': type,
        'date': date,
        'time': time,
        'studentNames': studentNames,
        'explanation': explanation,
      });

      if (documentReference.id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            margin: EdgeInsets.all(10),
            content: Text("Submitted successfully"),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(10),
          content: Text("Something went wrong"),
        ),
      );
    }
  }

  Future<void> getAllComplaints() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('complaints').get();

      // Process the querySnapshot to get the documents
      List<QueryDocumentSnapshot<Map<String, dynamic>>> complaints =
          querySnapshot.docs;

      for (QueryDocumentSnapshot<Map<String, dynamic>> complaint in complaints) {
        // Access data from each document
        Map<String, dynamic> complaintData = complaint.data();
        print('Complaint ID: ${complaint.id}');
        print('Type: ${complaintData['type']}');
        print('Date: ${complaintData['date']}');
        // Add more fields as needed
      }
    } catch (e) {
      print('Error getting complaints: $e');
    }
  }
}
