import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().checkLoginStatus(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan Logo App Anda jika ada
            Icon(
              Icons.fitness_center,
              size: 100,
              color: Color(0xFF6366F1), // Sesuaikan dengan AppColors.primary
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Color(0xFF6366F1)),
          ],
        ),
      ),
    );
  }
}
