import 'package:flutter/material.dart' as m;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:chain_fit_app/features/login_akun/views/login_akun_view.dart';
import 'package:chain_fit_app/features/daftar_akun/views/daftar_akun_view.dart';
import 'package:chain_fit_app/features/dashboard/view/dashboard_view.dart';

import 'package:chain_fit_app/features/status_membership/models/membership_models.dart';
import 'package:chain_fit_app/features/status_membership/view/membership_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyMembership = Membership(
      gymName: "Uget Uget Gym",
      type: "Premium Bulanan",
      startDate: DateTime(2025, 1, 10),
      endDate: DateTime(2026, 2, 10),
      sisaHari: 30,
      isActive: true,
    );

    return ShadcnApp(
      title: 'Chain Fit App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: LegacyColorSchemes.lightGray(),
        radius: 0.7,
      ),
      home: AppRouter(dummyMembership: dummyMembership),
    );
  }
}

// TAMBAHKAN INI
class AppRouter extends StatelessWidget {
  final Membership dummyMembership;

  const AppRouter({super.key, required this.dummyMembership});

  @override
  Widget build(BuildContext context) {
    return m.MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/membership_detail': (context) =>
            MembershipDetailPage(data: dummyMembership),

        '/login': (context) => const LoginAkunView(),
        '/register': (context) => const DaftarAkunView(),
        '/dashboard': (context) => DashboardView(),
      },
    );
  }
}
