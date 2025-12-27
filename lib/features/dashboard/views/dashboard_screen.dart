import 'package:chain_fit_app/features/detail_qr/views/detail_qr_view.dart';
import 'package:chain_fit_app/features/list_qr/models/list_qr_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import 'tabs/home_tab.dart'; // Import HomeTab yang baru dibuat

// Import halaman lain (Placeholder dulu)
// import '../../features/progress/views/progress_screen.dart';
// import '../../features/profile/views/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Daftar Halaman yang akan ditampilkan
  final List<Widget> _pages = [
    HomeTab(),                        // Index 0: Beranda
    const Center(child: Text("Halaman Progres")), // Index 1: Progres (Placeholder)
    AksesGymPage(membership: MembershipModel(id: 1, startDate: '', endDate: '', status: '', gym: GymModel(id: 1, name: 'Gym A', address: 'Jl. ABC'), package: PackageModel(id: 1, name: 'Basic', price: '', durationDays: 3)),),
    const Center(child: Text("Halaman Profil")),   // Index 3: Profil (Placeholder)
  ];

  @override
  void initState() {
    super.initState();
    // Load data dashboard tetap dilakukan di parent agar data ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().loadDashboardData();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      
      // LOGIC NAVIGASI UTAMA: Mengganti body berdasarkan index
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              // IndexedStack menjaga state halaman agar tidak reload saat pindah tab
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Membuat coak untuk FAB
        notchMargin: 8.0, // Jarak antara FAB dan Navbar
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 10,
        height: 70, // Tinggi Navbar
        padding: EdgeInsets.zero, // Reset padding bawaan BottomAppBar
        
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Jarak aman kiri-kanan
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [
              Row(
                children: [
                   _buildNavIcon(Icons.home_rounded, "Beranda", 0),
                    _buildNavIcon(Icons.bar_chart_rounded, "Progres", 1),
                    _buildNavIcon(Icons.qr_code_rounded, "QR Code", 2),
                   _buildNavIcon(Icons.person_rounded, "Profil", 3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
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
                fontSize: 10, // Ukuran font kecil agar rapi
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}