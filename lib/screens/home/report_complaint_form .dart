import 'package:anti_ragging/functions/firebaseFunction.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class ComplaintForm extends StatefulWidget {
  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _locationController = TextEditingController();
  final _explantionController = TextEditingController();
  final TextEditingController _complaintTypeController =
      TextEditingController();
  String selectedComplaintType = 'Ragging';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool _submitted = false;
  final _explanationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _complaintTypeController.text = selectedComplaintType;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white12,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(),
                    Column(
                      children: [
                        const SizedBox(height: 25),
                        const Text(
                          'Complaint Form',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          readOnly: true,
                          onTap: () {
                            _showComplaintTypePicker(context);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Complaint Type',
                            hintText: 'Select complaint type',
                            prefixIcon: Icon(Icons.arrow_drop_down),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          controller: _complaintTypeController,
                        ),
                        if (selectedComplaintType == 'Ragging')
                          const SizedBox(height: 12),
                        if (selectedComplaintType == 'Ragging')
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
                                text:
                                    "${selectedDate.toLocal()}".split(' ')[0]),
                          ),
                        if (selectedComplaintType == 'Ragging')
                          const SizedBox(height: 12),
                        if (selectedComplaintType == 'Ragging')
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
                        if (selectedComplaintType == 'Ragging')
                          const SizedBox(height: 12),
                        if (selectedComplaintType == 'Ragging')
                          TextField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Ragging Location',
                              hintText: 'Eg: near Library ',
                              prefixIcon: Icon(Icons.location_on),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        TextField(
                          minLines: 2,
                          maxLines: null,
                          controller: _explantionController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Explanation',
                            hintText: 'Enter your Explanation',
                            prefixIcon: Icon(Icons.details),
                            errorText:
                                _submitted && _explantionController.text.isEmpty
                                    ? 'This field is required'
                                    : null,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _explantionController.text.isEmpty &&
                                        _submitted
                                    ? Colors.red
                                    : Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 25.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Adjust the radius as needed
                            ),
                          ),
                          onPressed: () {
                            RegComplaint(context);
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void RegComplaint(BuildContext context) {
    String userId = currentUser?.uid ?? 'defaultUserId';

    setState(() {
      _submitted = true;
    });

    if (_explantionController.text.isEmpty) {
      _explanationFocusNode.requestFocus();
      return;
    }

    FirestoreServices.saveComplaint(
        userId,
        selectedComplaintType,
        selectedDate.toLocal().toString().split(' ')[0],
        selectedTime.format(context),
        _locationController.text,
        _explantionController.text,
        context);
  }

  void _showComplaintTypePicker(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Complaint Type'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3, // Number of complaint types
              itemBuilder: (BuildContext context, int index) {
                return _buildComplaintTypeItem(
                    ['Ragging', 'Maintenance', 'Academics'][index]);
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedComplaintType = result;
        _complaintTypeController.text = selectedComplaintType;
      });
    }
  }

  Widget _buildComplaintTypeItem(String value) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(value);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
    );
  }
}
