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
    // Tambahkan const untuk performa lebih baik (opsional)
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
    // Gunakan read karena kita berada di dalam callback event (onPressed)
    final vm = context.read<PaymentViewModel>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Konfirmasi Pembayaran",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text("Kamu yakin ingin melanjutkan pembayaran?"),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          SizedBox(
            width: 120,
            height: 42,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Batal"),
            ),
          ),
          SizedBox(
            width: 120,
            height: 42,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF636AE8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Lanjut",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await vm.createPayment(
      gymId: gymId,
      packageId: selectedPackage.id,
    );

    if (!success || vm.paymentData == null || !context.mounted) {
      if (vm.errorMessage != null && context.mounted) {
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

    // result bisa null (user keluar dari webview tanpa selesai)
    if (result == PaymentResult.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pembayaran berhasil ✅")));

      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (_) => false);
    } else if (result == PaymentResult.failed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pembayaran gagal ❌")));
    }
  } // ✅ FIX: Kurung kurawal penutup ditambahkan di sini

  @override
  Widget build(BuildContext context) {
    final pkg = selectedPackage;
    final price =
        int.tryParse(pkg.price.toString().replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final discount = 0;
    final total = price - discount;

    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(),
      child: Consumer<PaymentViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F8F8),
            appBar: AppBar(
              title: const Text("Pembayaran Member"),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ringkasan Paket Anda",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pkg.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rp ${_formatRupiah(pkg.price)}/bulan",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Durasi: ${pkg.durationDays} hari",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Divider(color: Colors.grey.shade200, thickness: 1),
                      const SizedBox(height: 12),
                      _RowPrice(
                        label: "Harga per bulan",
                        value: "Rp ${_formatRupiah(price)}",
                      ),
                      const SizedBox(height: 10),
                      _RowPrice(
                        label: "Diskon",
                        value: "Rp ${_formatRupiah(discount)}",
                        valueColor: Colors.green,
                      ),
                      const SizedBox(height: 14),
                      Divider(color: Colors.grey.shade200, thickness: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Pembayaran",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            "Rp ${_formatRupiah(total)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Optional benefit
                if (pkg.benefit.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Benefit Paket",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...pkg.benefit.map(
                          (b) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    b,
                                    style: const TextStyle(fontSize: 13.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF636AE8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  // Kita pass 'context' yang berasal dari builder Consumer,
                  // agar Provider bisa ditemukan oleh _confirmAndPay
                  onPressed: vm.isPaying ? null : () => _confirmAndPay(context),
                  child: vm.isPaying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Lanjut Pembayaran",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RowPrice extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _RowPrice({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
