import 'package:flutter/material.dart';

// Import halaman fitur yang sudah kamu punya
import 'features/video_panduan/video_panduan1.dart';
import 'features/formulir_daftar_gym/views/formulir_daftar_gym_view.dart';
//import 'features/search_gym/views/search_gym_views.dart';
import 'features/gymPreview/page/gym_preview_page.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const DashboardPage(), // Halaman utama
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Chain Fit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _DashboardButton(
              icon: Icons.login,
              label: 'Login',
              onTap: () {
                // TODO: arahkan ke halaman login kamu
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Halaman Login belum dibuat')),
                );
              },
            ),
            _DashboardButton(
              icon: Icons.app_registration,
              label: 'Register',
              onTap: () {
                // TODO: arahkan ke halaman register kamu
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Halaman Register belum dibuat')),
                );
              },
            ),
            _DashboardButton(
              icon: Icons.video_library,
              label: 'Video Panduan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoPanduanPage1()),
                );
              },
            ),
            _DashboardButton(
              icon: Icons.fitness_center,
              label: 'Gym Preview',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GymPreviewPage()),
                );
              },
            ),
            // _DashboardButton(
            //   icon: Icons.assignment,
            //   label: 'Formulir Pendaftaran Gym',
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const PendaftaranGymPage()),
            //     );
            //   },
            // ),
            // _DashboardButton(
            //   icon: Icons.search,
            //   label: 'Cari Gym',
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const GymSearchPage()),
            //     );
            //   },
            //),
          ],
        ),
      ),
    );
  }
}

/// Widget kecil untuk tombol menu dashboard
class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.onPrimaryContainer),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
