import 'package:chain_fit_app/features/qr_code/viewmodels/list_qr_viewmodel.dart';
import 'package:chain_fit_app/features/qr_code/views/detail_qr_screen.dart';
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
            child: ElevatedButton(
              onPressed: () => vm.loadMemberships(forceRefresh: true),
              child: const Text("Coba Lagi"),
            ),
          ),
        ],
      );
    }

    // Kosong
    if (vm.memberships.isEmpty) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 220),
          Center(child: Text("Tidak ada membership aktif.")),
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
        print("tesssssssssssssssssssss");
        print(vm.memberships[index]);

        return GestureDetector(
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
        );
      },
    );
  }
}
