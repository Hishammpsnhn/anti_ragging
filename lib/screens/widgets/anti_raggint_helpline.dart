import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AntiRaggingHelpline extends StatelessWidget {
  const AntiRaggingHelpline({Key? key}) : super(key: key);

  // _launchDialPad(String phoneNumber) async {
  //   final url = 'tel:$phoneNumber';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  //
  // _launchEmail(String email) async {
  //   final url = 'mailto:$email';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ANTI RAGGING HELP LINE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  // _launchDialPad('180025477845');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, size: 20),
                    SizedBox(width: 10),
                    Text(
                      '1800 2547 7845',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: InkWell(
                onTap: () {
                  //_launchEmail('meskc@gmail.com');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email, size: 18, color: Colors.grey),
                    // Set color here
                    SizedBox(width: 10),
                    Text(
                      'meskc@gmail.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
