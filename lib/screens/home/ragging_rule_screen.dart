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
                  "Lorem Ipsum is simply dummy text of the "
                      "printing and typesetting industry. "
                      "Lorem Ipsum has been the industry's "
                      "standard dummy text ever since the 1500s, "
                      "when an unknown printer took a galley of "
                      "type and scrambled it to make a type "
                      "specimen book. It has survived not only "
                      "five centuries, but also the leap into"
                      " electronic typesetting, remaining essentially"
                      " unchanged. It was popularised in the 1960s"
                      " with the release of Letraset sheets containing"
                      " Lorem Ipsum passages, and more recently with "
                      "desktop publishing software like Aldus PageMaker "
                      "including versions of Lorem Ipsum.",
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
