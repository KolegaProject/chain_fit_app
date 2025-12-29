import 'package:flutter/material.dart';
import 'app_colors.dart'; // Import warna yang sudah dibuat

class AppTextStyles {
  AppTextStyles._();

  // --- HEADERS / TITLES ---
  
  // Untuk Judul Halaman Besar (Misal: "Halo, Azriel")
  static const TextStyle pageTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Untuk Judul Section (Misal: "Menu Utama", "Keanggotaan Premium")
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold, // Bold
    color: AppColors.textPrimary,
  );

  // Untuk Judul Kartu (Misal: "Panduan", "Cari Gym")
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  // --- BODY TEXT ---
  
  // Untuk teks biasa / deskripsi
  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Untuk teks kecil (Misal: "Berlaku hingga...", label navbar)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // --- BUTTON TEXT ---
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}