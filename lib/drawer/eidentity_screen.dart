import 'package:flutter/material.dart';

class EIdentityScreen extends StatelessWidget {
  const EIdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF2C2C2C),
        centerTitle: true,
        title: const Text(
          "Assignment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          "This is the E-Identity Page",
          style: TextStyle(color: Colors.green, fontSize: 20),
        ),
      ),
    );
  }
}
