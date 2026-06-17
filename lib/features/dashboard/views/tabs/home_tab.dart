import 'package:chain_fit_app/core/constants/app_colors.dart';
import 'package:chain_fit_app/core/constants/app_text_styles.dart';
import 'package:chain_fit_app/features/search_gym/views/search_gym_screen.dart';
import 'package:chain_fit_app/features/video_panduan/view/panduan_alat_gym_view.dart';
import 'package:chain_fit_app/features/notification/views/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../models/active_package_model.dart';
import '../../models/gym_capacity_model.dart';

class HomeTab extends StatelessWidget {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil ViewModel
    final vm = context.watch<DashboardViewModel>();

    return RefreshIndicator(
      onRefresh: () => vm.loadDashboardData(forceRefresh: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(vm, context),
            const SizedBox(height: 24),
            _buildPremiumCard(vm, context),
            if (vm.packages.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildGymCapacityCard(vm, context),
            ],
            const SizedBox(height: 32),
            const Text("Menu Utama", style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),
            _buildMenuGrid(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DashboardViewModel vm, BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.profileBackground,
          backgroundImage: vm.user?.profileImage != null
              ? NetworkImage(vm.user!.profileImage!)
              : null,
          child: vm.user?.profileImage == null
              ? const Icon(
                  Icons.person,
                  color: AppColors.profileImage,
                  size: 30,
                )
              : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, ${vm.user?.username ?? 'Guest'}",
              style: AppTextStyles.pageTitle,
            ),
            const Text("Let's workout today!", style: AppTextStyles.bodyText),
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
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationPage()),
                  );
                },
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black87,
                ),
              ),
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPremiumCard(DashboardViewModel vm, BuildContext context) {
    // Skenario 1: Tidak punya paket sama sekali
    if (vm.packages.isEmpty) {
      return _buildEmptyStateCard(context);
    }

    // Skenario 2: Punya paket (Tampilkan Carousel)
    return ColoredBox(
      color: AppColors.background,
      child: SizedBox(
        height: 200,
        child: PageView.builder(
          controller: _pageController,
          padEnds: false,
          itemCount: vm.packages.length,
          itemBuilder: (context, index) {
            final package = vm.packages[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: _buildSinglePackageCard(package),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGymCapacityCard(DashboardViewModel vm, BuildContext context) {
    if (vm.packages.isEmpty) {
      return const SizedBox.shrink();
    }

    final activePackage = vm.packages.firstWhere(
      (pkg) => pkg.status == 'AKTIF',
      orElse: () => vm.packages.first,
    );

    if (activePackage.gymId == 0) {
      return const SizedBox.shrink();
    }

    final capacity = vm.gymCapacity;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kepadatan Gym",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activePackage.gymName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (capacity != null) _buildStatusBadge(capacity.status),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: vm.isLoadingCapacity
                        ? null
                        : () => vm.fetchGymCapacity(activePackage.gymId),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: vm.isLoadingCapacity
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF6366F1),
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.refresh_rounded,
                              size: 16,
                              color: Color(0xFF6366F1),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (vm.isLoadingCapacity && capacity == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (capacity == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Gagal memuat data kepadatan",
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
                TextButton(
                  onPressed: () => vm.fetchGymCapacity(activePackage.gymId),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Coba Lagi",
                    style: TextStyle(color: Color(0xFF6366F1), fontSize: 13),
                  ),
                ),
              ],
            )
          else
            _buildCapacityDetails(capacity),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toUpperCase()) {
      case 'AVAILABLE':
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF15803D);
        label = "Tersedia";
        break;
      case 'CROWDED':
        bgColor = const Color(0xFFFEF9C3);
        textColor = const Color(0xFF854D0E);
        label = "Ramai";
        break;
      case 'FULL':
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFF991B1B);
        label = "Penuh";
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF4B5563);
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildCapacityDetails(GymCapacityModel capacity) {
    final double percentage = capacity.maxCapacity > 0
        ? capacity.currentUsers / capacity.maxCapacity
        : 0.0;
    final displayPercentage = (percentage * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$displayPercentage% terisi",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            Text(
              "${capacity.currentUsers}/${capacity.maxCapacity} Orang",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoItem("Tersedia", "${capacity.availableSpace} Slot", Icons.event_seat_rounded),
            _buildInfoItem("Pengguna", "${capacity.currentUsers} Orang", Icons.people_rounded),
            _buildInfoItem("Kapasitas", "${capacity.maxCapacity} Slot", Icons.fitness_center_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade400),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      {
        'title': 'Panduan',
        'icon': Icons.play_circle_fill_rounded,
        'color': Colors.orange.shade100,
        'iconColor': Colors.orange,
      },
      {
        'title': 'Cari Gym',
        'icon': Icons.location_on_rounded,
        'color': Colors.blue.shade100,
        'iconColor': Colors.blue,
      },
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
            // Logic navigasi
            if (item['title'] == 'Cari Gym') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchGymView()),
              );
            } else if (item['title'] == 'Panduan') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PanduanAlatGymPage()),
              );
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

  Widget _buildEmptyStateCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF64748B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Belum ada Paket",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Yuk mulai perjalanan sehatmu dengan berlangganan paket gym!",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchGymView()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            child: const Text("Cari Gym Sekarang"),
          ),
        ],
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
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.fitness_center,
              size: 150,
              color: Colors.white.withOpacity(0.1),
            ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        package.status, // "AKTIF"
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Icon(Icons.verified, color: Colors.white70, size: 20),
                  ],
                ),
                const Spacer(),
                Text(
                  package.packageName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  package.gymName,
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
}
