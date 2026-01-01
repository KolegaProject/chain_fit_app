import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/list_qr_model.dart';
import '../viewmodels/detail_qr_viewmodel.dart';

class AksesGymPage extends StatefulWidget {
  final MembershipModel membership;
  const AksesGymPage({super.key, required this.membership});

  @override
  State<AksesGymPage> createState() => _AksesGymPageState();
}

class _AksesGymPageState extends State<AksesGymPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailQrViewModel>().generateQrToken(
        widget.membership.gym.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final gymName = widget.membership.gym.name;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4F5DFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Akses Gym",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              "Pindai untuk Masuk $gymName",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 20),

            _QrSection(gymId: widget.membership.gym.id),

            const SizedBox(height: 15),
            const Text(
              "Pindai kode QR ini di pintu masuk gym.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            _RefreshButton(gymId: widget.membership.gym.id),

            const SizedBox(height: 30),
            _TipsBox(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _QrSection extends StatelessWidget {
  final int gymId;
  const _QrSection({required this.gymId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailQrViewModel>(
      builder: (_, vm, __) {
        if (vm.isLoading) {
          return const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.hasError) {
          return SizedBox(
            height: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                const Text("Gagal memuat QR"),
                TextButton(
                  onPressed: () => vm.generateQrToken(gymId),
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        }

        if (!vm.hasData) {
          return const SizedBox(height: 240);
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: QrImageView(
            data: vm.qrToken!.token,
            size: 220,
            version: QrVersions.auto,
          ),
        );
      },
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final int gymId;
  const _RefreshButton({required this.gymId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailQrViewModel>(
      builder: (_, vm, __) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: vm.isLoading ? null : () => vm.generateQrToken(gymId),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text("Perbarui Kode QR"),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFF4F4FF),
              foregroundColor: const Color(0xFF4F5DFF),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TipsBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tips Penggunaan",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 16),
          _TipItem(text: "Pastikan layar ponsel Anda cukup cerah."),
          SizedBox(height: 12),
          _TipItem(text: "QR Code bersifat rahasia dan terbatas."),
          SizedBox(height: 12),
          _TipItem(text: "Tekan Perbarui jika QR gagal."),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;
  const _TipItem({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lightbulb_outline, size: 20, color: Colors.black45),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
