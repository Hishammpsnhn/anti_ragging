import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MentorTimeSchedule extends StatefulWidget {


  const MentorTimeSchedule({Key? key,}) : super(key: key);

  @override
  State<MentorTimeSchedule> createState() => _MentorTimeScheduleState();
}
TimeOfDay stringToTimeOfDay(String timeString) {
  if (timeString.isEmpty) {
    // Handle empty string case
    return TimeOfDay.now();
  }

  final dateTime = DateFormat.Hm().parse(timeString);
  return TimeOfDay.fromDateTime(dateTime);
}
class _MentorTimeScheduleState extends State<MentorTimeSchedule> {
  TimeOfDay _startTime = userData?.fromTime != null ? stringToTimeOfDay(userData!.fromTime) : TimeOfDay.now();
  TimeOfDay _endTime = userData?.toTime != null ? stringToTimeOfDay(userData!.toTime) : TimeOfDay.now();
  int _numberOfSchedules = userData?.noOfAppointment ?? 0;


  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (pickedTime != null && pickedTime != _startTime) {
      setState(() {
        _startTime = pickedTime;
        _updateUser();
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (pickedTime != null && pickedTime != _endTime) {
      setState(() {
        _endTime = pickedTime;
        _updateUser();
      });
    }
  }

  void _updateUser() {
      FirestoreServices.updateUser(
        context,
        currentUser?.uid ?? 'defaultUserId',
        _startTime,
        _endTime,
        _numberOfSchedules,
      );
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TIME SCHEDULE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _selectStartTime(context),
                  child: Text(
                    'From: ${_startTime.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectEndTime(context),
                  child: Text(
                    'To: ${_endTime.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of Appointments:',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<int>(
                  value: _numberOfSchedules,
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        _numberOfSchedules = value;
                        _updateUser();
                      });
                    }
                  },
                  items: List.generate(
                    10, // You can customize the number of options
                        (index) => DropdownMenuItem<int>(
                      value: index + 0,
                      child: Text('${index + 0}'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

