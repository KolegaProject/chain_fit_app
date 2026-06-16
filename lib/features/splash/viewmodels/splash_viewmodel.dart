import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';

class SplashViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  Future<void> checkLoginStatus(BuildContext context) async {
    // Simulasi delay splash screen agar tidak terlalu cepat
    await Future.delayed(const Duration(seconds: 2));

    final token = await _storageService.getAccessToken();

    if (context.mounted) {
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding'); // Onboarding
      }
    }
  }
}
