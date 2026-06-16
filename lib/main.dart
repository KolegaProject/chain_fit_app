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
import 'package:chain_fit_app/core/services/storage_service.dart';
import 'package:chain_fit_app/features/dashboard/views/dashboard_screen.dart';
import 'features/auth/viewmodels/login_viewmodel.dart';
import 'features/auth/views/login_screen.dart';
import 'features/splash/viewmodels/splash_viewmodel.dart';
import 'features/splash/views/splash_screen.dart';
import 'features/notification/viewmodels/notification_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final storageService = StorageService();
  final token = await storageService.getAccessToken();
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return AppRouter(isLoggedIn: isLoggedIn);
  }
}

class AppRouter extends StatelessWidget {
  final bool isLoggedIn;
  const AppRouter({super.key, required this.isLoggedIn});

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
        home: isLoggedIn ? const DashboardScreen() : const SplashScreen(),
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const Onboarding1Screen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
