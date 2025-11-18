import 'package:chain_fit_app/features/daftar_akun/views/daftar_akun_view.dart';
import 'package:chain_fit_app/features/dashboard/view/dashboard_view.dart';
import 'package:flutter/material.dart' as m;
import 'package:chain_fit_app/features/login_akun/views/login_akun_view.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'Chain Fit App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: LegacyColorSchemes.lightGray(),
        radius: 0.7,
      ),
      home: const AppRouter(),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return m.MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginAkunView(),
        '/register': (context) => const DaftarAkunView(),
        '/dashboard': (context) => DashboardView(),
        // dst...
      },
    );
  }
}
