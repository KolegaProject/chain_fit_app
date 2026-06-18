import 'package:chain_fit_app/features/qr_code/viewmodels/list_qr_viewmodel.dart';
import 'package:chain_fit_app/features/qr_code/views/detail_qr_screen.dart';
import 'package:chain_fit_app/features/search_gym/views/search_gym_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuQrPage extends StatefulWidget {
  const MenuQrPage({super.key});

  @override
  State<MenuQrPage> createState() => _MenuQrPageState();
}

class _MenuQrPageState extends State<MenuQrPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListQrViewModel>().loadMemberships();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    "Menu QR",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Consumer<ListQrViewModel>(
                builder: (context, vm, child) {
                  return RefreshIndicator(
                    onRefresh: () => vm.loadMemberships(forceRefresh: true),
                    child: _buildBody(vm),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ListQrViewModel vm) {
    // Loading
    if (vm.showFullScreenLoader) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 220),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    // Error
    if (vm.showFullScreenError) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 140),
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            "Gagal memuat data:\n${vm.showFullScreenError}",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Center(
            child: Semantics(
              label: 'retry_qr_list_button',
              identifier: 'retry_qr_list_button',
              button: true,
              child: ElevatedButton(
                key: const Key('retry_qr_list_button'),
                onPressed: () => vm.loadMemberships(forceRefresh: true),
                child: const Text("Coba Lagi"),
              ),
            ),
          ),
        ],
      );
    }

    // Kosong
    if (vm.memberships.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 64,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    "Belum Ada Membership Aktif",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Akses QR Code gym hanya dapat dibuat setelah Anda terdaftar pada paket membership aktif. Temukan gym terdekat dan pilih paket terbaik Anda!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Semantics(
                    label: 'empty_search_gym_button',
                    identifier: 'empty_search_gym_button',
                    button: true,
                    child: ElevatedButton.icon(
                      key: const Key('empty_search_gym_button'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchGymView(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        "Cari Gym Sekarang",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // List
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: vm.memberships.length,
      itemBuilder: (context, index) {
        final membership = vm.memberships[index];

        final String keyName = 'qr_item_${membership.id}';
        return Semantics(
          label: keyName,
          identifier: keyName,
          button: true,
          child: GestureDetector(
            key: Key(keyName),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AksesGymPage(membership: membership),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFFE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.qr_code_2,
                      size: 40,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          membership.gym.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                membership.gym.address,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: membership.status == "AKTIF"
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            membership.status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: membership.status == "AKTIF"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
