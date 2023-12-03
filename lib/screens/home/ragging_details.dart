import 'package:flutter/material.dart';

class Ragging_Details_page extends StatelessWidget {
  final Key? key;
  final String name;

  Ragging_Details_page({this.key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text(name),
        ),
      ),
    );
  }
}
