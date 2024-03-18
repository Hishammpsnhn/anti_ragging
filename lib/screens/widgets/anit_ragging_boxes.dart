import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/mentoring_reg.dart';
import 'package:anti_ragging/screens/home/ragging_report.dart';
import 'package:anti_ragging/screens/home/ragging_rule_screen.dart';
import 'package:anti_ragging/screens/home/report_complaint_form%20.dart';
import 'package:anti_ragging/screens/widgets/complaint_dialog.dart';
import 'package:flutter/material.dart';

class AntiRaggingBoxes extends StatelessWidget {
  final bool? isAdmin;
  final bool? isCell;
  final _complaintNoController = TextEditingController();

   AntiRaggingBoxes({Key? key, this.isAdmin,this.isCell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ANTI RAGGGING',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if(isCell == true)
                  (_buildRaggingBox(
                      "Click here  to check ragging case report",
                      'assets/antiRagging1.png', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Ragging_reports_Page(isCell: isCell),
                      ),
                    );
                  }, context)),
                  if (isAdmin != null && isAdmin!)
                    (_buildRaggingBox(
                        "Click here  to check ragging case report",
                        'assets/antiRagging1.png', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Ragging_reports_Page(),
                        ),
                      );
                    }, context)),
                  if (isAdmin == false  )
                  _buildRaggingBox("Click here to lodge a complaint",
                      'assets/complaint-6161776_640.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComplaintForm(),
                          ),
                        );
                      }, context),
                  if ( isAdmin ==false)
                  _buildRaggingBox("Mentoring",
                      'assets/download.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentoringPage(),
                          ),
                        );
                      }, context),
                  _buildRaggingBox("Download Anti-Ragging undertaking",
                      'assets/123-1234019_rules-to-follow-hd-png-download.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ragging_rule_Page(),
                          ),
                        );
                      }, context),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'COMPLAINT STATUS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Enter Complaint no. to check status',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            _Complaint_status(context)
          ],
        ),
      ),
    );
  }

  Widget _buildRaggingBox(String text, String imagePath, void Function() onTap,
      context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        width: 180,
        height: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xffdec9cd), Color(0xffa4aee5)],
            stops: [0.25, 0.75],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ), // Customize the box color as needed
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 75,
                height: 75,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _Complaint_status(BuildContext context) {

    return Container(
      // Adjust the width according to your preference
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _complaintNoController,
              decoration: InputDecoration(
                labelText: 'Complaint no',
                hintText: 'complaint no',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.numbers),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 8), // Adjust the padding
              ),
            ),
          ),
          const SizedBox(width: 30),
          ElevatedButton(
            onPressed: () {
              complaintStatus(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Border radius
              ),
            ),
            child: const Text(
              "SUBMIT",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  void complaintStatus(BuildContext context) async {
    final _complaintNo = _complaintNoController.text;

    // Check if _complaintNo is a valid integer
    if (int.tryParse(_complaintNo) == null) {
      ComplaintDialog.showInvalidCaseNumberDialog(context);
      return;
    }

    bool? solvedStatus = await FirestoreServices.findSolvedStatus(
        int.tryParse(_complaintNo)!, context);

    if (solvedStatus == null) {
      ComplaintDialog.showInvalidCaseNumberDialog(context);
    } else if (!solvedStatus) {
      ComplaintDialog.showPendingDialog(context, _complaintNo);
    } else {
      ComplaintDialog.showSolvedDialog(context, _complaintNo);
    }
  }
}