import 'package:chain_fit_app/features/daftar_akun/views/daftar_akun_view.dart';
import 'package:flutter/material.dart';
import 'package:chain_fit_app/features/login_akun/views/login_akun_view.dart';
import 'package:chain_fit_app/features/dashboard/view/dashboard_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chain Fit App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginAkunView(),
        '/register': (context) => const DaftarAkunView(),
        '/dashboard': (context) => DashboardView(),
        // Tambahkan route lain di sini jika diperlukan
      },
    );
  }
}
