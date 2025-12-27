import 'package:flutter/material.dart';

import 'package:chain_fit_app/features/formulir_daftar_gym/model/registrant.dart';
import 'package:chain_fit_app/features/gymPreview/model/paket_gym_model.dart';

import 'package:chain_fit_app/features/payment/page/payment_webview_page.dart';
import 'package:chain_fit_app/features/payment/service/payment_service.dart';

class PaymentMethodPage extends StatefulWidget {
  final GymPackage selectedPackage;
  final Registrant registrant;

  const PaymentMethodPage({
    super.key,
    required this.selectedPackage,
    required this.registrant,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final PaymentService _paymentService = PaymentService();
  bool _isPaying = false;

  String _formatRupiah(dynamic value) {
    final raw = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.isEmpty) return value.toString();
    final chars = raw.split('');
    final buf = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      final idxFromEnd = chars.length - i;
      buf.write(chars[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write('.');
    }
    return buf.toString();
  }

  Future<void> _confirmAndPay() async {
    if (_isPaying) return;

    final bool? lanjut = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
        );
      },
    );

    // ✅ batal/close dialog => jangan loading
    if (lanjut != true) {
      if (mounted) setState(() => _isPaying = false);
      return;
    }

    setState(() => _isPaying = true);

    try {
      final pkg = widget.selectedPackage;

      final data = await _paymentService.createPayment(
        packageId: pkg.id,
        gymId: pkg.gymId,
      );


      final bool? isSuccess = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebViewPage(url: data.redirectUrl),
        ),
      );
      if (!mounted) return;

      if (isSuccess == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/dashboard',
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pembayaran berhasil ✅")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal membuat pembayaran: $e")));
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pkg = widget.selectedPackage;

    final priceInt =
        int.tryParse(pkg.price.toString().replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final discount = 0;
    final total = priceInt - discount;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("Pembayaran Member"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      // ✅ Ringkasan di page
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 14),
                Divider(color: Colors.grey.shade200, thickness: 1),
                const SizedBox(height: 12),
                _RowPrice(
                  label: "Harga per bulan",
                  value: "Rp ${_formatRupiah(priceInt)}",
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
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
            onPressed: _isPaying ? null : _confirmAndPay,
            child: _isPaying
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
