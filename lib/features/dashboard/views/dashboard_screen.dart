import 'package:chain_fit_app/features/detail_qr/views/detail_qr_view.dart';
import 'package:chain_fit_app/features/list_qr/models/list_qr_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/dashboard_viewmodel.dart';
import 'tabs/home_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Daftar Halaman yang akan ditampilkan (untuk tab selain yang dipush)
  final List<Widget> _pages = [
    HomeTab(), // 0: Beranda
    const Center(child: Text("Halaman Progres")), // 1: Progres
    const SizedBox(), // 2: Placeholder karena QR Code sekarang dipush
    const Center(child: Text("Halaman Profil")), // 3: Profil
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().loadDashboardData();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<DashboardViewModel>().loadDashboardData(forceRefresh: true);
  }

  void _onItemTapped(int index) {
    // Fokus: QR Code pakai Navigator.push
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AksesGymPage(
            membership: MembershipModel(
              id: 1,
              startDate: '',
              endDate: '',
              status: '',
              gym: GymModel(id: 1, name: 'Gym A', address: 'Jl. ABC'),
              package: PackageModel(
                id: 1,
                name: 'Basic',
                price: '',
                durationDays: 3,
              ),
            ),
          ),
        ),
      );
      return;
    }

    // Tab lain tetap ganti index (IndexedStack)
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null && vm.user == null
                ? Center(child: Text(vm.errorMessage!))
                : SafeArea(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: [
                          if (vm.isRefetching)
                            const LinearProgressIndicator(minHeight: 2),
                            _pages[_selectedIndex],
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 10,
        height: 70,
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : Colors.grey.shade400,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : Colors.grey.shade400,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
