import 'package:chain_fit_app/features/auth/viewmodels/register_viewmodel.dart';
import 'package:chain_fit_app/features/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:chain_fit_app/features/auth/views/register_screen.dart';
import 'package:chain_fit_app/features/gym_preview/viewmodels/gym_preview_viewmodel.dart';
import 'package:chain_fit_app/features/qr_code/viewmodels/detail_qr_viewmodel.dart';
import 'package:chain_fit_app/features/screen/onboarding/onboarding_1_screen.dart';
import 'package:chain_fit_app/features/search_gym/viewmodels/search_gym_viewmodel.dart';
import 'package:chain_fit_app/features/qr_code/viewmodels/list_qr_viewmodel.dart';
import 'package:chain_fit_app/features/status_membership/viewmodels/membership_list_viewmodel.dart';
import 'package:chain_fit_app/features/status_membership/viewmodels/membership_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:chain_fit_app/features/dashboard/views/dashboard_screen.dart';
import 'features/auth/viewmodels/login_viewmodel.dart';
import 'features/auth/views/login_screen.dart';
import 'features/splash/viewmodels/splash_viewmodel.dart';
import 'features/splash/views/splash_screen.dart';
import 'features/notification/viewmodels/notification_viewmodel.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppRouter();
  }
}

// TAMBAHKAN INI
class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => SearchGymViewModel()),
        ChangeNotifierProvider(create: (_) => GymPreviewViewModel()),
        ChangeNotifierProvider(create: (_) => ListQrViewModel()),
        ChangeNotifierProvider(create: (_) => DetailQrViewModel()),
        ChangeNotifierProvider(create: (_) => MembershipViewModel()),
        ChangeNotifierProvider(create: (_) => MembershipListViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: MaterialApp(
        title: 'Chain Fit App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const Onboarding1Screen(),
        routes: {
          '/onboarding': (context) => const Onboarding1Screen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
