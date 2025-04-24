import 'package:erp_app/screens/splashwrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 10), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashWrapper()),
      );
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🍃 Animated Green Gradient Background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.green.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),

          // 🟢 Glowing Green Orbs
          Positioned(
            top: 100,
            left: 30,
            child: _floatingOrb(80, Colors.green.withOpacity(0.15)),
          ),
          Positioned(
            bottom: 120,
            right: 40,
            child: _floatingOrb(100, Colors.greenAccent.withOpacity(0.1)),
          ),
          Positioned(
            bottom: 220,
            left: 90,
            child: _floatingOrb(60, Colors.lightGreenAccent.withOpacity(0.12)),
          ),

          // 🔥 Center Lottie & App Name
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎞️ Your Lottie animation
                Lottie.asset(
                  'assets/splashback.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),

                // 🧩 App Name with Glow
                Text(
                  'Prezzence',
                  style: GoogleFonts.bungeeSpice(
                    textStyle: TextStyle(
                      fontSize: 50,
                      color: const Color.fromARGB(255, 231, 236, 241),
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🍏 Floating Orb Widget
  Widget _floatingOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 30, spreadRadius: 5)],
      ),
    );
  }
}
