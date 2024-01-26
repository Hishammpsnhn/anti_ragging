import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirestoreServices {
  static Future<List<Map<String, dynamic>>> getMentoringForLoggedInUser(
      String mentorId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('mentoring')
        .where('mentorId', isEqualTo: mentorId)
        .where('isDone', isEqualTo: false)
        .get();

    List<Map<String, dynamic>> mentoringData = [];

    for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Add the document ID to the data map
      data['docId'] = doc.id;

      // Get the studentId from the mentoring data
      String studentId = data['studentId'];

      // Fetch the user details for the student
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(studentId)
          .get();

      if (userSnapshot.exists) {
        // If the user exists, add the user details to the mentoring data
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        data['name'] = userData['name'];
        data['department'] = userData['department'];
      }

      mentoringData.add(data);
    }

    return mentoringData;
  }


  static saveUser(
      String name, email, uid, String department, String phone) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'department': department,
      'phoneNumber': phone,
      'admin': false,
      'fromTime': null,
      'toTime': null,
      'numberOfSchedules': 0,
    });
  }

  static updateUser(
    context,
    String uid,
    TimeOfDay fromTime,
    TimeOfDay toTime,
    int numberOfSchedules,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fromTime': fromTime.format(context),
      'toTime': toTime.format(context),
      'numberOfSchedules': numberOfSchedules,
    });
  }

  static Future<void> saveComplaint(
    String userId,
    String type,
    String date,
    String time,
    String location,
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
        'location': location,
        'explanation': explanation,
        'solved': false,
        'caseNumber': currentSize + 1,
      });

      if (documentReference.id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            margin: EdgeInsets.all(10),
            content:
                Text("Submitted successfully. Case number: ${currentSize + 1}"),
          ),
        );
        Navigator.pop(context);
        // final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendNotificationToAdmin');
        // await callable.call({
        //   'complaintId': currentSize + 1,
        // });
        //
        // // Subscribe to the admin topic for notifications
        // FirebaseMessaging.instance.subscribeToTopic('admin');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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

  static Future<List<Map<String, dynamic>>> getAllMentors() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('mentor', isEqualTo: true)
              .get();

      // Process the querySnapshot to get the documents
      List<Map<String, dynamic>> mentors =
          querySnapshot.docs.map((mentorDocument) {
        return {
          'id': mentorDocument.id, // Document ID
          ...mentorDocument.data(), // Document data
        };
      }).toList();

      print("mentos $mentors");
      return mentors;
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

  static Future<void> bookMentoring(
    String userId,
    String date,
    String time,
    String sheduleTime,
    String mentorId,
    BuildContext context,
  ) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference =
          await FirebaseFirestore.instance.collection('mentoring').add({
        'studentId': userId,
        'date': date,
        'time': time,
        'mentorId': mentorId,
        'isDone': false,
        "scheduleTime": sheduleTime
      });

      if (documentReference.id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            margin: EdgeInsets.all(10),
            content: Text("Booked successfully"),
          ),
        );
        Navigator.pop(context);
        final DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(mentorId);
        try {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapshot = await transaction.get(userDoc);

            if (snapshot.exists) {
              Map<String, dynamic> userData =
                  snapshot.data() as Map<String, dynamic>;

              int currentNumberOfSchedules = userData['numberOfSchedules'] ?? 0;

              // Ensure the value doesn't go below zero
              int newNumberOfSchedules = (currentNumberOfSchedules - 1)
                  .clamp(0, double.infinity)
                  .toInt();

              transaction
                  .update(userDoc, {'numberOfSchedules': newNumberOfSchedules});
            }
          });
        } catch (e) {
          print('Error decrementing numberOfSchedules: $e');
        }
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

Future<int> getMenotringCount(String mentorId) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('mentoring')
        .where('mentorId', isEqualTo: mentorId)
        .where('isDone', isEqualTo: false)
        .get();

    return querySnapshot.size;
  } catch (e) {
    throw Exception('Error fetching total cases: $e');
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
Future<void> updateMentoringStatus(String docId) async {
  try {
    CollectionReference mentoringCollection =
    FirebaseFirestore.instance.collection('mentoring');

    await mentoringCollection.doc(docId).update({
      'isDone': true,
    });

    print('Mentoring with document ID $docId marked as done.');
  } catch (error) {
    print('Error updating mentoring status: $error');
  }
}