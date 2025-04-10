import 'package:flutter/material.dart';

class EIdentityScreen extends StatelessWidget {
  const EIdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Identity"),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          "This is the E-Identity Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
