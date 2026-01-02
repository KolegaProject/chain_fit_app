import 'package:chain_fit_app/features/auth/viewmodels/login_viewmodel.dart';
import 'package:chain_fit_app/features/auth/viewmodels/register_viewmodel.dart';
import 'package:chain_fit_app/features/auth/views/login_screen.dart';
import 'package:chain_fit_app/features/status_membership/viewmodels/membership_list_viewmodel.dart';
import 'package:chain_fit_app/features/status_membership/views/membership_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:chain_fit_app/features/status_membership/viewmodels/membership_viewmodel.dart';
import 'package:chain_fit_app/features/status_membership/views/membership_detail_page.dart';

import 'package:chain_fit_app/features/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:chain_fit_app/features/search_gym/viewmodels/search_gym_viewmodel.dart';
import 'package:chain_fit_app/features/gym_preview/viewmodels/gym_preview_viewmodel.dart';
import 'package:chain_fit_app/features/qr_code/viewmodels/list_qr_viewmodel.dart';
import 'package:chain_fit_app/features/qr_code/viewmodels/detail_qr_viewmodel.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GymBroApp());
}

class GymBroApp extends StatelessWidget {
  const GymBroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => SearchGymViewModel()),
        ChangeNotifierProvider(create: (_) => GymPreviewViewModel()),
        ChangeNotifierProvider(create: (_) => ListQrViewModel()),
        ChangeNotifierProvider(create: (_) => DetailQrViewModel()),
        ChangeNotifierProvider(create: (_) => MembershipViewModel()),
        ChangeNotifierProvider(create: (_) => MembershipListViewModel()),
        ChangeNotifierProvider(create: (_) => MembershipViewModel()),
      ],

      child: MaterialApp(
        title: 'GymBro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'SF Pro',
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
