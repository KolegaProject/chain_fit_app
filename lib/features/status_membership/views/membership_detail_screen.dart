import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/membership_viewmodel.dart';
import '../models/membership_model.dart';

class MembershipDetailPage extends StatefulWidget {
  final Membership? membershipData;

  const MembershipDetailPage({super.key, this.membershipData});

  @override
  State<MembershipDetailPage> createState() => _MembershipDetailPageState();
}

class _MembershipDetailPageState extends State<MembershipDetailPage> {
  @override
  void initState() {
    super.initState();
    // 1. Panggil Data saat buka halaman
    Future.microtask(() {
      final vm = Provider.of<MembershipViewModel>(context, listen: false);
      if (widget.membershipData != null) {
        vm.setMembership(widget.membershipData);
      } else {
        vm.fetchMembershipData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipViewModel>(
      builder: (context, vm, child) {
        // --- LOGIC STATE (Loading, Error, Success) ---

        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.membership == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Detail Membership")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Data tidak ditemukan"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.fetchMembershipData(),
                    child: const Text("Refresh Data"),
                  ),
                ],
              ),
            ),
          );
        }

        // Ambil data yang sudah siap
        final data = vm.membership!;

        // --- TAMPILAN UTAMA (UI) ---
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
            title: Text(
              data.gymName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _MembershipStatusCard(data: data),
                const SizedBox(height: 20),
                _MembershipDetailCard(data: data),
                const SizedBox(height: 20),
                _ActionButtons(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// WIDGET UI DIPISAH DI BAWAH SINI BIAR KODINGAN DI ATAS BERSIH
// ============================================================================

class _MembershipStatusCard extends StatelessWidget {
  final Membership data;
  const _MembershipStatusCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.type,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.isActive ? "Aktif" : "Nonaktif",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text("Sisa Durasi"),
          const SizedBox(height: 4),
          Text(
            "${data.sisaHari} hari tersisa",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: data.sisaHari > 30 ? 1.0 : (data.sisaHari / 30),
            minHeight: 6,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}

class _MembershipDetailCard extends StatelessWidget {
  final Membership data;
  const _MembershipDetailCard({required this.data});

  String _formatDate(DateTime date) {
    // Helper format tanggal simpel
    const bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return "${date.day} ${bulan[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail Keanggotaan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _rowItem("Tanggal Mulai", _formatDate(data.startDate)),
          const SizedBox(height: 10),
          _rowItem("Tanggal Berakhir", _formatDate(data.endDate)),
        ],
      ),
    );
  }

  Widget _rowItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Perpanjang Sekarang",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text("Lihat Riwayat Pembayaran"),
          ),
        ),
      ],
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
    ],
  );
}
