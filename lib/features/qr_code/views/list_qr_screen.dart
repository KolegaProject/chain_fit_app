import 'package:chain_fit_app/core/enums/view_state.dart';
import 'package:chain_fit_app/core/widgets/app_empty_state.dart';
import 'package:chain_fit_app/core/widgets/app_error_state.dart';
import 'package:chain_fit_app/core/widgets/app_loading_state.dart';
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _buildStateWidget(vm.state, vm),
    );
  }

  Widget _buildStateWidget(ViewState state, ListQrViewModel vm) {
    switch (state) {
      case ViewState.loading:
        return const AppLoadingState(key: ValueKey('loading'));
      case ViewState.error:
        return AppErrorState(
          key: const ValueKey('error'),
          errorMessage:
              vm.errorMessage ??
              "Gagal memuat data membership. Silakan periksa koneksi internet Anda dan coba lagi.",
          onRetry: () => vm.loadMemberships(forceRefresh: true),
          retryButtonSemanticsLabel: 'retry_qr_list_button',
          retryButtonKey: const Key('retry_qr_list_button'),
        );
      case ViewState.empty:
        return AppEmptyState(
          key: const ValueKey('empty'),
          icon: Icons.qr_code_scanner_rounded,
          title: "Belum Ada Membership Aktif",
          subtitle:
              "Akses QR Code gym hanya dapat dibuat setelah Anda terdaftar pada paket membership aktif. Temukan gym terdekat dan pilih paket terbaik Anda!",
          actionButtonText: "Cari Gym Sekarang",
          onActionPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchGymView()),
            );
          },
          actionButtonSemanticsLabel: 'empty_search_gym_button',
          actionButtonKey: const Key('empty_search_gym_button'),
          buttonIcon: Icons.search_rounded,
        );
      case ViewState.success:
        return ListView.builder(
          key: const ValueKey('success_list'),
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
}
