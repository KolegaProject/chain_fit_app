import 'package:flutter/material.dart';

class AppColors {
  // --- MAIN BRAND ---
  // Warna utama aplikasi (Indigo dari kodingan anda: 0xFF6366F1)
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5); // Versi agak gelap untuk gradient
  static const Color primaryLight = Color(0xFF818CF8); // Versi agak terang

  // --- BACKGROUNDS ---
  // static const Color background = Color(0xFFF8F9FE); // Abu-abu sangat muda (bg scaffold)
  static const Color background = Color(0xFFe8e8fd);
  static const Color surface = Colors.white; // Warna kartu/container
  //Colors.grey.shade200
  
  // --- TEXT COLORS ---
  // 0xFF1F2937 adalah warna text gelap yg anda pakai
  static const Color textPrimary = Color(0xFF1F2937); 
  static const Color textSecondary = Colors.grey; 
  static const Color textWhite = Colors.white;

  // --- STATUS / UTILITY ---
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;

  // --- SPECIFIC UI ---
  // Warna border atau shadow
  static const Color border = Color(0xFFE5E7EB); // Grey shade 200 equivalent
  static const Color profileImage = Colors.grey;
  static Color shadow = Colors.grey.withValues(alpha: 0.5);
}