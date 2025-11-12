// main.dart
import 'package:flutter/material.dart' as m; // alias biar nggak bentrok
import 'package:shadcn_flutter/shadcn_flutter.dart'; // <- penting
import 'features/video_panduan/panduan_alat_gym.dart';
// import 'features/formulir_daftar_gym/views/formulir_daftar_gym_view.dart';
// import 'features/gymPreview/page/gym_preview_page.dart';
import 'features/search_gym/views/search_gym_views.dart.dart'; // perbaiki import yg dobel .dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'Chain Fit App',
      // Theme untuk shadcn_flutter. Boleh kamu oprek sesuai selera.
      theme: ThemeData(
        colorScheme: LegacyColorSchemes.lightGray(), // contoh dari docs
        radius: 0.7,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tetap bisa pakai Material widgets. Karena kita alias 'm.', nggak bentrok
    return m.Scaffold(
      appBar: m.AppBar(
        title: const Text('Dashboard Chain Fit'),
        centerTitle: true,
      ),
      body: const _DashboardGrid(),
    );
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid();

  @override
  Widget build(BuildContext context) {
    return m.Padding(
      padding: const m.EdgeInsets.all(20),
      child: m.GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          _DashboardButton(
            icon: m.Icons.login,
            label: 'Login',
            onTap: () {
              m.ScaffoldMessenger.of(context).showSnackBar(
                const m.SnackBar(content: Text('Halaman Login belum dibuat')),
              );
            },
          ),
          _DashboardButton(
            icon: m.Icons.app_registration,
            label: 'Register',
            onTap: () {
              m.ScaffoldMessenger.of(context).showSnackBar(
                const m.SnackBar(
                  content: Text('Halaman Register belum dibuat'),
                ),
              );
            },
          ),
          _DashboardButton(
            icon: m.Icons.video_library,
            label: 'Video Panduan',
            onTap: () {
              Navigator.push(
                context,
                m.MaterialPageRoute(builder: (_) => const PanduanAlatGymPage()),
              );
            },
          ),
          // _DashboardButton(
          //   icon: m.Icons.fitness_center,
          //   label: 'Gym Preview',
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       m.MaterialPageRoute(builder: (_) => const GymPreviewPage()),
          //     );
          //   },
          // ),
          _DashboardButton(
            icon: m.Icons.search,
            label: 'Cari Gym',
            onTap: () {
              Navigator.push(
                context,
                m.MaterialPageRoute(builder: (_) => const GymSearchPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final m.IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardButton({
    // super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return m.InkWell(
      onTap: onTap,
      borderRadius: m.BorderRadius.circular(16),
      child: m.Ink(
        decoration: m.BoxDecoration(
          color: m.Theme.of(context).colorScheme.primaryContainer,
          borderRadius: m.BorderRadius.circular(16),
        ),
        child: m.Column(
          mainAxisAlignment: m.MainAxisAlignment.center,
          children: [
            m.Icon(
              icon,
              size: 48,
              color: m.Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const m.SizedBox(height: 12),
            m.Text(
              label,
              textAlign: m.TextAlign.center,
              style: m.TextStyle(
                fontSize: 14,
                color: m.Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: m.FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
