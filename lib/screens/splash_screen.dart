// screens/splash_screen.dart
import 'package:erp_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:erp_app/bloc/auth_bloc/auth_event.dart';
import 'package:erp_app/screens/dashboard_screen.dart';
import 'package:erp_app/screens/splashwrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
   
        // User is not logged in, navigate to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashWrapper()),
        );
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 20, 0),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/background.jpeg', fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: const Text(
                'Welcome to\nEdumarshal !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  height: 1.5,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Image.asset(
                'assets/centerimage2.jpeg',
                width: 400,
                height: 400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 100.0,
                right: 150.0,
                bottom: 100.0,
              ),
              child: Lottie.asset(
                'assets/animation.json',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
