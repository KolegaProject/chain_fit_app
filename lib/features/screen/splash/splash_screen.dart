import 'package:flutter/material.dart';
import 'dart:async';
import '../onboarding/onboarding_1_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Onboarding1Screen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF5B6EF5),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Icon(
            Icons.fitness_center_rounded,
            size: 64,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
