import 'package:flutter/material.dart';

class Onboarding4Screen extends StatelessWidget {
  const Onboarding4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Image
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                'Mulai Perjalanan Kebugaran Anda',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              const Text(
                'BergaBunglah dengan GymBro hari ini untuk mencapai tujuan kebugaran Anda. Mari bergerak menuju versi terbaik dari Anda!',
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to login or home screen
                    // Navigator.pushReplacement(...);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B6EF5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Register Account Button
              TextButton(
                onPressed: () {
                  // Navigate to register screen
                },
                child: const Text(
                  'Daftar Akun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5B6EF5),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Register Gym Button
              TextButton(
                onPressed: () {
                  // Navigate to gym registration
                },
                child: const Text(
                  'Daftar Gym',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5B6EF5),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Page Indicator

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
