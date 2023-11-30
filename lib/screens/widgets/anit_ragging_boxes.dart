import 'package:flutter/material.dart';

class AntiRaggingBoxes extends StatelessWidget {
  const AntiRaggingBoxes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AntiRagging',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildRaggingBox("Download Anti-Ragging undertaking",
                        'assets/antiRagging.png'),
                    _buildRaggingBox("Box 1", 'assets/antiRagging.png'),
                    _buildRaggingBox("Box 1", 'assets/antiRagging.png'),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildRaggingBox(String text, String imagePath) {
    return GestureDetector(
      onTap: () {
        print("clickedd");
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(8.0),
        width: 180,
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffdec9cd), Color(0xffa4aee5)],
            stops: [0.25, 0.75],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ), // Customize the box color as needed
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 75,
                height: 75,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
