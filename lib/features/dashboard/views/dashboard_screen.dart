import 'package:chain_fit_app/features/dashboard/models/active_package_model.dart';
import 'package:chain_fit_app/features/search_gym/views/search_gym_views.dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dashboard_viewmodel.dart';

// Ganti import ini sesuai lokasi file project Anda
import 'package:chain_fit_app/features/list_qr/views/list_qr_view.dart'; 
// import 'package:chain_fit_app/features/search_gym/views/search_gym_views.dart';
// import 'package:chain_fit_app/features/video_panduan/view/panduan_alat_gym_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    // Fetch data saat layar dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().loadDashboardData();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Logika navigasi halaman bisa ditambahkan di sini
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
              ? Center(child: Text(vm.errorMessage!))
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- 1. HEADER PROFILE ---
                        _buildHeader(vm),
                        
                        const SizedBox(height: 24),

                        // --- 2. PREMIUM CARD ---
                        _buildPremiumCard(vm),

                        const SizedBox(height: 32),

                        // --- 3. MENU GRID ---
                        const Text(
                          "Menu Utama",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMenuGrid(context),
                      ],
                    ),
                  ),
                ),
      
      // --- 4. BOTTOM NAVIGATION BAR (MODERN) ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuQrPage()));
        },
        backgroundColor: const Color(0xFF6366F1),
        elevation: 4,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black12,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(Icons.home_rounded, "Beranda", 0),
              _buildNavIcon(Icons.bar_chart_rounded, "Progres", 1),
              const SizedBox(width: 48), // Spacer untuk FAB di tengah
              _buildNavIcon(Icons.person_rounded, "Profil", 2),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET COMPONENTS

  Widget _buildHeader(DashboardViewModel vm) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: vm.user?.profileImage != null
              ? NetworkImage(vm.user!.profileImage!)
              : null,
          child: vm.user?.profileImage == null
              ? const Icon(Icons.person, color: Colors.grey, size: 30)
              : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, ${vm.user?.username ?? 'Guest'}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const Text(
              "Let's workout today!",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        // Notification Icon dengan Badge
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(Icons.notifications_outlined, color: Colors.black87),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

 Widget _buildPremiumCard(DashboardViewModel vm) {
    // Skenario 1: Tidak punya paket sama sekali
    if (vm.packages.isEmpty) {
      return _buildEmptyStateCard();
    }

    // Skenario 2: Punya paket (Tampilkan Carousel)
    return SizedBox(
      height: 200, // Tentukan tinggi agar tidak error RenderFlex
      child: PageView.builder(
        controller: _pageController,
        padEnds: false, // Agar item pertama mulai dari kiri (opsional)
        itemCount: vm.packages.length,
        itemBuilder: (context, index) {
          final package = vm.packages[index];
          // Bungkus dengan padding agar ada jarak antar kartu saat digeser
          return Padding(
            padding: const EdgeInsets.only(right: 12.0), 
            child: _buildSinglePackageCard(package),
          );
        },
      ),
    );
  }

  Widget _buildSinglePackageCard(ActivePackageModel package) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(Icons.fitness_center, size: 150, color: Colors.white.withOpacity(0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        package.status, // "AKTIF"
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                    const Icon(Icons.verified, color: Colors.white70, size: 20),
                  ],
                ),
                const Spacer(),
                Text(
                  package.packageName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                 Text(
                  package.gymName, // Menampilkan nama Gym
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "Berlaku hingga: ${package.formattedExpiryDate}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Kartu Kosong (Jika user belum beli paket)
  Widget _buildEmptyStateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF64748B), // Warna abu-abu
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Belum ada Paket",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Yuk mulai perjalanan sehatmu dengan berlangganan paket gym!",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
               // Navigasi ke halaman cari gym
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            child: const Text("Cari Gym Sekarang"),
          )
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      {'title': 'Panduan', 'icon': Icons.play_circle_fill_rounded, 'color': Colors.orange.shade100, 'iconColor': Colors.orange},
      {'title': 'Cari Gym', 'icon': Icons.location_on_rounded, 'color': Colors.blue.shade100, 'iconColor': Colors.blue},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return InkWell(
          onTap: () {
            // Logic navigasi manual disini jika diperlukan
            if (item['title'] == 'Cari Gym') {
                // Navigator.push...
                Navigator.push(context, MaterialPageRoute(builder: (_) => SearchGymView(accessToken: '<ACCESS_TOKEN>',)));
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['iconColor'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavIcon(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        // UBAH DISINI: Gunakan symmetric, kurangi vertikal jadi 4 atau 2
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade400,
              size: 26, 
            ),
            const SizedBox(height: 4), 
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade400,
                fontSize: 12, // Jika masih error, bisa turunkan ke 10
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}