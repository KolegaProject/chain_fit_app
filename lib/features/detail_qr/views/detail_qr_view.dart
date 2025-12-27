import 'package:chain_fit_app/features/detail_qr/models/detail_qr_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Pastikan sudah tambah di pubspec.yaml
import '../../../core/services/api_service.dart';
import '../../list_qr/models/list_qr_model.dart';

class AksesGymPage extends StatefulWidget {
  final MembershipModel membership;
  const AksesGymPage({super.key, required this.membership});

  @override
  State<AksesGymPage> createState() => _AksesGymPageState();
}

class _AksesGymPageState extends State<AksesGymPage> {
  final ApiService _apiService = ApiService();
  QrTokenResponse? _qrData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchQrData();
  }

  // Fungsi untuk mengambil token QR dari API
  Future<void> _fetchQrData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Memanggil API target: {{url}}/api/v1/attendance/{id}/qr/me
      final result = await _apiService.generateQrToken(widget.membership.id);

      setState(() {
        _qrData = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              "Pindai untuk Masuk ${widget.membership.gym.name}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // AREA GENERATED QR CODE
            _buildQrSection(),

            const SizedBox(height: 15),
            const Text(
              "Pindai kode QR ini di pintu masuk gym.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 20),
            const Text(
              "ID Anggota:",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 4),
            Text(
              _qrData?.memberId ?? "Loading...",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4F5DFF),
              ),
            ),

            const SizedBox(height: 20),

            // Button Perbarui QR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchQrData,
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
            ),

            const SizedBox(height: 30),

            // Tips Penggunaan Box
            _buildTipsBox(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan QR atau Loading atau Error
  Widget _buildQrSection() {
    if (_isLoading) {
      return const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            const Text("Gagal memuat QR"),
            TextButton(onPressed: _fetchQrData, child: const Text("Coba Lagi"))
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: QrImageView(
        data: _qrData!.token, // String JWT dari API
        version: QrVersions.auto,
        size: 220.0,
        gapless: false,
      ),
    );
  }

  Widget _buildTipsBox() {
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
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _TipItem(
            text: "Pastikan layar ponsel Anda cukup cerah untuk pemindaian.",
          ),
          SizedBox(height: 12),
          _TipItem(
            text: "QR Code ini bersifat rahasia dan memiliki batas waktu penggunaan.",
          ),
          SizedBox(height: 12),
          _TipItem(
            text: "Jika gagal, coba bersihkan layar atau tekan tombol Perbarui.",
          ),
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