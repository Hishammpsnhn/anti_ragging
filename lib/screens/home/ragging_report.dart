import 'package:anti_ragging/screens/home/ragging_details.dart';
import 'package:flutter/material.dart';

class Ragging_report_Page extends StatelessWidget {
  const Ragging_report_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text("name $index"),
                subtitle: Text("something"),
                leading: CircleAvatar(),
                trailing: Text("12:00"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return Ragging_Details_page(name: 'person $index');
                      },
                    ),
                  );
                },
              );
            },
            separatorBuilder: (ctx, index) {
              return Divider();
            },
            itemCount: 20),
      ),
    );
  }
}
