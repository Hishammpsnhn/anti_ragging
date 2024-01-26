import 'dart:ffi';

import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:anti_ragging/screens/widgets/appBar.dart';
import 'package:flutter/material.dart';

class MentoringPage extends StatefulWidget {
  const MentoringPage({super.key});

  @override
  State<MentoringPage> createState() => _MentoringPageState();
}

class _MentoringPageState extends State<MentoringPage> {
  List<Map<String, dynamic>> mentors = [];
  String selectedMentorId = '';
  bool _loading = false;
  bool _mentorsLoading = false;
  String _sheduleTime = '';

  @override
  void initState() {
    super.initState();
    getAllMentors();
  }

  Future<void> getAllMentors() async {
    _mentorsLoading = true;
    List<Map<String, dynamic>> fetchedMentors =
    await FirestoreServices.getAllMentors();
    setState(() {
      mentors = fetchedMentors;
    });
    _mentorsLoading = false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            App_Bar(
              logout: false,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5E3FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 20),
                        const Text(
                          'Select Mentor',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if(mentors.length <= 0 && !_mentorsLoading)
                          const Text(
                            'Mentors not Available',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.red
                            ),
                          ),
                        if(_mentorsLoading)
                          Center(child: CircularProgressIndicator()),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            // Replace "Name" with the actual name from your data
                            String name = mentors[index]['name'];
                            String phone = mentors[index]['phoneNumber'];
                            String? fromTime = mentors[index]['fromTime'];
                            String? toTime = mentors[index]['toTime'];
                            int numberOfSchedules = mentors[index]['numberOfSchedules'] ?? 0;
                            String mentorId = mentors[index]['id'];

                            return  fromTime != null && toTime != null
                            ? ListTile(
                              title: Text(name),
                              subtitle: Text(phone),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                // Set your desired background color
                                child: Text(
                                  name[0],
                                  // Display the first letter of the name
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              trailing: Container(
                                child: Opacity(
                                  opacity: numberOfSchedules != 0 ? 1.0 : 0.5, // Change the condition as needed
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$fromTime - $toTime",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${numberOfSchedules.toString()} slot only", // Convert int to String
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: selectedMentorId == mentorId ? Colors.green : Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                ),
                                padding: EdgeInsets.all(8.0),
                              ),
                              onTap: () {
                                setState(() {
                                  if(numberOfSchedules != 0){
                                    if(selectedMentorId == mentorId){
                                      selectedMentorId = '';
                                      _sheduleTime = '';
                                    }else{
                                      selectedMentorId = mentorId;
                                      _sheduleTime =  "$fromTime - $toTime";
                                    }
                                  }

                                });
                              },
                            )
                            :Container();
                          },
                          separatorBuilder: (ctx, index) {
                            return Divider();
                          },
                          itemCount: mentors.length,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity, // Make the button full width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 25.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () {
                              bookMentor(context);
                            },
                            child: _loading
                                ? const CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                            ) :
                            const Text(
                              "BOOK MENTOR",
                              style: TextStyle(
                                fontSize: 18, // Adjust the font size as needed
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                          ),
                        ),
                        // ... other form widgets ...
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]
          ,
        )
        ,
      )
      ,
    );
  }
  void bookMentor(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    if (selectedMentorId == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(5),
          content: Text("Please select Mentor"),
        ),
      );
      setState(() {
        _loading = false;
      });
      return;
    }
    String userId = currentUser?.uid ?? 'defaultUserId';
    String time = selectedTime.format((context));
    String date = selectedDate.toLocal().toString().split(' ')[0];
    String sheduleTime = _sheduleTime;
    await FirestoreServices.bookMentoring(
        userId, date, time, sheduleTime, selectedMentorId, context);
    setState(() {
      _loading = false;
    });
  }

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();



}
