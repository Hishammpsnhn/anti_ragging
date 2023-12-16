import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirestoreServices {
  static saveUser(
      String name, email, uid, String department, String phone) async {
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
      int currentSize = await getTotalCases();
      DocumentReference<Map<String, dynamic>> documentReference =
          await FirebaseFirestore.instance.collection('complaints').add({
        'studentId': userId,
        'type': type,
        'date': date,
        'time': time,
        'studentNames': studentNames,
        'explanation': explanation,
        'solved': false,
        'caseNumber': currentSize + 1,
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

  static Future<List<Map<String, dynamic>>> getAllComplaints() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('complaints').get();

      // Process the querySnapshot to get the documents
      List<Map<String, dynamic>> complaints =
          querySnapshot.docs.map((complaint) {
        return complaint.data();
      }).toList();

      // Sort complaints based on caseNumber in descending order
      complaints.sort((a, b) {
        int caseNumberA = a['caseNumber'];
        int caseNumberB = b['caseNumber'];
        return caseNumberB.compareTo(caseNumberA); // Compare in reverse order
      });

      return complaints;
    } catch (e) {
      print('Error getting complaints: $e');
      return [];
    }
  }

// Function to get a student by ID from Firestore
  static Future<Map<String, dynamic>> getStudentById(String studentId) async {
    CollectionReference studentsCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentReference documentReference = studentsCollection.doc(studentId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  //get complaint status baseon case number
  static Future<bool?> findSolvedStatus(
      int caseNumber, BuildContext context) async {
    try {
      CollectionReference complaintsCollection =
          FirebaseFirestore.instance.collection('complaints');
      QuerySnapshot querySnapshot = await complaintsCollection
          .where('caseNumber', isEqualTo: caseNumber)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var complaintData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        return complaintData['solved'] as bool? ?? false;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching solved status: $e');
      return null;
    }
  }
}

Future<int> getTotalCases() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('complaints').get();

    return querySnapshot.size;
  } catch (e) {
    throw Exception('Error fetching total cases: $e');
  }
}

Future<int> getPendingCasesCount() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('complaints')
        .where('solved', isEqualTo: false)
        .get();

    return querySnapshot.size;
  } catch (e) {
    throw Exception('Error fetching pending cases: $e');
  }
}

Future<void> updateCaseStatus(int caseNumber) async {
  try {
    CollectionReference complaints =
        FirebaseFirestore.instance.collection('complaints');
    QuerySnapshot querySnapshot =
        await complaints.where('caseNumber', isEqualTo: caseNumber).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot complaintDoc = querySnapshot.docs.first;
      await complaintDoc.reference.update({'solved': true});
      print('Case $caseNumber marked as solved.');
    } else {
      print('Complaint with case number $caseNumber not found.');
    }
  } catch (error) {
    print('Error updating case status: $error');
  }
}
