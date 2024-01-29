import 'package:anti_ragging/functions/authFunctions.dart';
import 'package:anti_ragging/screens/auth/register_page.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:anti_ragging/screens/splash/splash_page.dart';
import 'package:anti_ragging/screens/widgets/complaint_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _EmailController = TextEditingController();
  final _PasswordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Column(
                  children: [
                    const Text(
                      'CampUs',
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 111, 20, 136),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _EmailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your Email Address',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple, // Set the background color to blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Adjust the border radius as needed
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Adjust the padding as needed
                      ),
                      onPressed: () {
                        checkLogin(context);
                      },
                      child: _loading
                          ?const  CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Login',
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
                    Text(
                      "Don't have an account?",
                      style: TextStyle(  color: Color.fromARGB(255, 111, 20, 136),),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return RegisterPage();
                        }));
                        // Add functionality for the "Don't have an account?" button here
                      },
                      child: Text(
                        'Sign Up',
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
    );
  }

  void checkLogin(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final _email = _EmailController.text;
    final _password = _PasswordController.text;
    if(_email.isNotEmpty && _password.isNotEmpty){
      await AuthServices.signinUser(_email, _password, context);
    }else{
      ComplaintDialog.snackBar(context, SnackBarType.error, "Fill all fields");
    }


    setState(() {
      _loading = false;
    });
    // if(_username == _password){
    //   final _sharedPrefs = await SharedPreferences.getInstance();
    //   await _sharedPrefs.setBool(SAVE_KEY_NAME, true);

    // }else{
    //     ScaffoldMessenger.of(ctx)
    //         .showSnackBar(const SnackBar(
    //           behavior: SnackBarBehavior.floating,
    //           backgroundColor:Colors.red,
    //           margin: EdgeInsets.all(10),
    //           content: Text("somthing wrong!")));
    //     //show Dialog
    //   //
    // }
  }
}
