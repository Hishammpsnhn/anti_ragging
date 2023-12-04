import 'package:flutter/material.dart';

class ComplaintForm extends StatefulWidget {
  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _complaintTypeController = TextEditingController();
  String selectedComplaintType = 'Ragging';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.grey),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(),
                Column(
                  children: [
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
                    const SizedBox(height: 12),
                    TextFormField(
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Date',
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
                        labelText: 'Time',
                        hintText: 'Select time',
                        prefixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      controller: TextEditingController(
                          text: "${selectedTime.format(context)}"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFC20BF3),
                        elevation: 5,
                      ),
                      onPressed: () {
                        checkLogin(context);
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
    );
  }

  void checkLogin(BuildContext context) {
    final _email = _emailController.text;
    final _password = _passwordController.text;
    print('Selected Complaint Type: $selectedComplaintType');
    print('Email: $_email');
    print('Password: $_password');
    print('Selected Date: ${selectedDate.toLocal()}');
    print('Selected Time: ${selectedTime.format(context)}');
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
                return _buildComplaintTypeItem(['Ragging', 'Maintenance', 'Academics'][index]);
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
