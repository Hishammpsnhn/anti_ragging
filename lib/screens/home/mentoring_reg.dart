import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/widgets/appBar.dart';
import 'package:flutter/material.dart';

class MentoringPage extends StatefulWidget {
  const MentoringPage({super.key});

  @override
  State<MentoringPage> createState() => _MentoringPageState();
}

class _MentoringPageState extends State<MentoringPage> {
  List<Map<String, dynamic>> mentors = [];

  @override
  void initState() {
    super.initState();
    getAllMentors();
  }

  Future<void> getAllMentors() async {
    List<Map<String, dynamic>> fetchedMentors =
        await FirestoreServices.getAllMentors();
    print(fetchedMentors);
    setState(() {
      mentors = fetchedMentors;
    });
  }
  String selectedMentorId = '';

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
                        const Text(
                          'Schedule Mentoring',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Ragging Date',
                            hintText: 'Select date',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          controller: TextEditingController(
                              text: "${selectedDate.toLocal()}".split(' ')[0]),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          readOnly: true,
                          onTap: () {
                            _selectTime(context);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Ragging Time',
                            hintText: 'Select time',
                            prefixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          controller: TextEditingController(
                              text: "${selectedTime.format(context)}"),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Select Mentor',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            // Replace "Name" with the actual name from your data
                            String name = mentors[index]['name'];
                            String phone = mentors[index]['phoneNumber'];
                            String mentorId = mentors[index]['id'];
                            return ListTile(
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
                              trailing: selectedMentorId == mentorId
                                  ? Icon(Icons.check, color: Colors.green) // Display tick icon if selected
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedMentorId = mentorId;
                                });
                              },
                            );
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
                              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () {
                              bookMentor();
                            },
                            child: Text(
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
          ],
        ),
      ),
    );
  }
  void bookMentor (){
    print(selectedTime.format((context)));
    print(selectedDate.toLocal().toString().split(' ')[0]);
    print(selectedMentorId);

  }
  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
}
