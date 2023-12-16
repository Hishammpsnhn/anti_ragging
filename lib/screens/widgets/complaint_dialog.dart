// complaint_dialog.dart

import 'package:flutter/material.dart';

class ComplaintDialog {
  static void showInvalidCaseNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Invalid Case Number', style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),),
          content: Text('Please enter a valid case number.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showPendingDialog(BuildContext context, String complaintNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Case is Pending',style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.blue
          ),),
          content: Text('The complaint with case number $complaintNo is still pending.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showSolvedDialog(BuildContext context, String complaintNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Case is Solved',style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.green
          ),),
          content: Text('The complaint with case number $complaintNo is solved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
