import 'package:anti_ragging/screens/auth/login_page.dart';
import 'package:anti_ragging/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SAVE_KEY_NAME = 'userLoggedIn';
class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
   void initState() {
    print("initSTate");
    checkUserLogedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 108, 9, 144),
              Color.fromARGB(255, 65, 33, 243),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            'CampUs',
            style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.w900,
              color: Colors.white, // Text color on the background
            ),
          ),
        ),
      ),
    );
  }

   void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

    Future<void> gotoLogin()async{
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=> LoginPage()));
  }

  Future<void> checkUserLogedIn()async{
    final _sharedPrefs = await SharedPreferences.getInstance();
    final _userLoggedIn = _sharedPrefs.getBool(SAVE_KEY_NAME);
    print(_userLoggedIn);
    if(_userLoggedIn == false || _userLoggedIn == null ){
      gotoLogin();
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>HomeScreen()));
    }
  }
}
