import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: const Column(
        children: [
          ListTile(
            title: Text("Bucket Names"),
          ),
          ListTile(
            title: Text(
              "Bucket 1 Categories",
            ),
          ),
          ListTile(
            title: Text(
              "Bucket 2 Categories",
            ),
          ),
          ListTile(
            title: Text(
              "Global Corellation",
            ),
          ),
          ListTile(
            title: Text(
              "Degrees of Freedom",
            ),
          ),
          ListTile(
            title: Text("Model Assumptions"),
          ),
        ],
      ),
    );
  }
}
