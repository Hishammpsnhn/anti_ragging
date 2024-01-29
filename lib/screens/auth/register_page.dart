import 'package:anti_ragging/functions/authFunctions.dart';
import 'package:anti_ragging/screens/auth/login_page.dart';
import 'package:anti_ragging/screens/widgets/complaint_dialog.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _UsernameController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _ConfirmPasswordController = TextEditingController();
  final _PhoneController = TextEditingController();
  final _EmailController = TextEditingController();
  final _DepartmentController = TextEditingController();
  final _AdmissionNumberController = TextEditingController();
  bool _loading = false;
  String? _selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE5AAF6),
                  Color(0xFFE1CFE7),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Column(
                    children: [
                      const Text(
                        "Let's Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 111, 20, 136),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _UsernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _PasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _ConfirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Confirm Password',
                          hintText: 'ReEnter your password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _PhoneController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Phone Number',
                          hintText: 'Enter your Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _EmailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email',
                          hintText: 'Enter your Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        items: ['CS', 'History', 'Commerce', 'Science', 'BVoc','Faculty']
                            .map((department) {
                          return DropdownMenuItem<String>(
                            value: department,
                            child: Text(
                              department,
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value!;
                          });
                        },
                        style: TextStyle(color: Colors.black),
                        icon: Icon(Icons.arrow_drop_down),
                        dropdownColor: Colors.grey[200],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Department',
                          hintText: 'Select your Department',
                          prefixIcon: Icon(Icons.class_),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // Adjust the above values based on your preference
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      const SizedBox(height: 10),
                      if(_selectedDepartment != 'Faculty')
                      TextField(
                        controller: _AdmissionNumberController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Admission Number',
                          hintText: 'Enter your Admission Number',
                          prefixIcon: Icon(Icons.confirmation_num),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Forgot Password'),
                                    content: const Text(
                                        'Please check your email for instructions to reset your password.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(  color: Color.fromARGB(255, 111, 20, 136),),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkRegister(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          // Set the background color to blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Adjust the border radius as needed
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0), // Adjust the padding as needed
                        ),
                        child: _loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Register',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 1.5)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(  color: Color.fromARGB(255, 111, 20, 136),),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return LoginPage();
                          }));
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(  color: Color.fromARGB(255, 111, 20, 136),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkRegister(BuildContext context) async {
    setState(() {
      _loading = true;
    });

    final _username = _UsernameController.text;
    final _password = _PasswordController.text;
    final _confirmPassword = _ConfirmPasswordController.text;
    final _phoneNumber = _PhoneController.text;
    final _email = _EmailController.text;
    final _department = _selectedDepartment;
    final _admissionNumber = _AdmissionNumberController.text;

    if (_password == _confirmPassword) {
      if (_areAllFieldsNotEmpty([
            _username,
            _password,
            _confirmPassword,
            _phoneNumber,
            _email,
            if(_department != 'Faculty') _admissionNumber,
          ]) &&
          _department != null) {
        await AuthServices.signupUser(
          _email,
          _password,
          _username,
          _department,
          _phoneNumber,
          context,
        );
      } else {
        ComplaintDialog.snackBar(
          context,
          SnackBarType.error,
          "Fill all required fields",
        );
      }
    } else {
      ComplaintDialog.snackBar(
        context,
        SnackBarType.error,
        "Password doesn't match Confirm Password",
      );
    }

    setState(() {
      _loading = false;
    });
  }

  bool _areAllFieldsNotEmpty(List<String> fields) {
    return fields.every((field) => field.isNotEmpty);
  }
}
