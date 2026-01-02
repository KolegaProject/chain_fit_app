import 'package:chain_fit_app/features/gym_preview/models/gym_package_model.dart';
import 'package:chain_fit_app/features/payment/domain/payment_result.dart';
import 'package:chain_fit_app/features/payment/viewmodels/payment_viewmodel.dart';
import 'package:chain_fit_app/features/payment/views/payment_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethodPage extends StatelessWidget {
  final int gymId;
  final GymPackage selectedPackage;

  const PaymentMethodPage({
    super.key,
    required this.gymId,
    required this.selectedPackage,
  });

  String _formatRupiah(dynamic value) {
    final raw = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.isEmpty) return value.toString();

    final buf = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      final idx = raw.length - i;
      buf.write(raw[i]);
      if (idx > 1 && idx % 3 == 1) buf.write('.');
    }
    return buf.toString();
  }

  Future<void> _confirmAndPay(BuildContext context) async {
    final vm = context.read<PaymentViewModel>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Pembayaran"),
        content: const Text("Kamu yakin ingin melanjutkan pembayaran?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Lanjut"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await vm.createPayment(
      gymId: gymId, // ✅ FIX: pakai gymId dari page
      packageId: selectedPackage.id,
    );

    if (!success || vm.paymentData == null || !context.mounted) {
      if (vm.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
      }
      return;
    }

    final result = await Navigator.push<PaymentResult>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebViewPage(url: vm.paymentData!.redirectUrl),
      ),
    );

    if (!context.mounted) return;

    if (result == PaymentResult.success) {
      // ✅ Redirect ke homepage/dashboard
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (_) => false);

      // Kalau kamu mau snackbar tetap tampil setelah pindah halaman,
      // idealnya tampilkan snackbar di halaman dashboard-nya.
    } else if (result == PaymentResult.failed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pembayaran gagal ❌")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pkg = selectedPackage;
    final price =
        int.tryParse(pkg.price.toString().replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(),
      child: Consumer<PaymentViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text("Pembayaran Member")),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pkg.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp ${_formatRupiah(price)} / bulan",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: vm.isPaying
                          ? null
                          : () => _confirmAndPay(context),
                      child: vm.isPaying
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text("Lanjut Pembayaran"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
