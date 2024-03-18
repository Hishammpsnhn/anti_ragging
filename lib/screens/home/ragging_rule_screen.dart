import 'package:flutter/material.dart';

class Ragging_rule_Page extends StatelessWidget {
  const Ragging_rule_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Text(
                  "Ragging Rule",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Ragging refers to any form of physical or mental abuse, including bullying, intimidation, or humiliation, often conducted by senior students against newcomers in educational institutions. It is illegal and has serious consequences.In many countries, including India, where ragging has been a serious issue, anti-ragging rules and regulations have been implemented. These rules aim to prevent and eliminate ragging from educational institutions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
