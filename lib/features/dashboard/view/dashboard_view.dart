import 'package:flutter/material.dart';
import '../model/dashboard_model.dart';
import 'package:chain_fit_app/features/video_panduan/panduan_alat_gym.dart';
import 'package:chain_fit_app/features/search_gym/views/search_gym_views.dart.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
  // End of _DashboardViewState
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardUser user = DashboardUser(
    name: 'Azriel',
    profileImageUrl:
        'https://randomuser.me/api/portraits/men/1.jpg', // Dummy image
    isPremium: true,
    premiumExpiry: '31 Desember 2030',
    notificationCount: 3,
  );

  int _selectedBottomNav = 0;

  final List<DashboardMenuItem> menuItems = [
    DashboardMenuItem(title: 'Video Panduan', iconAsset: 'video_library'),
    DashboardMenuItem(title: 'Cari Gym', iconAsset: 'search'),
  ];

  void _navigateTo(String page) {
    // TODO: Replace with real navigation logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigasi ke: $page')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(user.profileImageUrl),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Halo,',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {},
                      ),
                      if (user.notificationCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              user.notificationCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Keanggotaan Premium',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.fitness_center,
                            color: Color(0xFF6366F1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.isPremium ? 'Aktif' : 'Tidak Aktif',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Berlaku hingga: ${user.premiumExpiry}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Lihat Detail',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: menuItems.asMap().entries.map((entry) {
                  final item = entry.value;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (item.title == 'Video Panduan') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PanduanAlatGymPage(),
                            ),
                          );
                        } else if (item.title == 'Cari Gym') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GymSearchPage(),
                            ),
                          );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIconData(item.iconAsset),
                            color: const Color(0xFF6366F1),
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'video_library':
        return Icons.video_library;
      case 'search':
        return Icons.search;
      default:
        return Icons.circle;
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.fitness_center, 'Beranda', 0),
          _buildNavItem(Icons.calendar_today, 'Aktivitas', 1),
          Transform.translate(
            offset: const Offset(0, -24),
            child: FloatingActionButton(
              onPressed: () => _navigateTo('scan'),
              backgroundColor: const Color(0xFF6366F1),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),
          ),
          _buildNavItem(Icons.show_chart, 'Progres', 2),
          _buildNavItem(Icons.person, 'Profil', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool selected = _selectedBottomNav == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBottomNav = index;
        });
        _navigateTo(label.toLowerCase());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? const Color(0xFF6366F1) : Colors.grey,
            size: 28,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF6366F1) : Colors.grey,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
