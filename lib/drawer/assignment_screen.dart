import 'package:flutter/material.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment"),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          "This is the Assignment Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
