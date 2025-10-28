import 'package:flutter/material.dart';
import '../model/gym_model.dart';

class PaymentSummaryPage extends StatelessWidget {
  final Package pkg;
  final String method;

  const PaymentSummaryPage({
    super.key,
    required this.pkg,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    int discount = 50000;
    int adminFee = 10000;
    int total = pkg.price - discount + adminFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran Member"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Rincian Pembayaran =====
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.receipt_long, color: Colors.black54),
                        SizedBox(width: 6),
                        Text(
                          "Rincian Pembayaran",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRow("Paket", pkg.name),
                    _buildRow("Harga", "Rp ${pkg.price}"),
                    _buildRow(
                      "Diskon",
                      "- Rp $discount",
                      valueColor: Colors.green,
                    ),
                    _buildRow("Biaya Admin", "Rp $adminFee"),
                    const Divider(height: 24),
                    _buildRow(
                      "Total Pembayaran",
                      "Rp $total",
                      isBold: true,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 16),
                    _buildRow("Metode Pembayaran", method),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Status Pembayaran"),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.access_time,
                                color: Colors.orange,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Menunggu Pembayaran",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildRow("Jatuh Tempo", "2024-08-15"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== Informasi Pengguna =====
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person, color: Colors.black54),
                        SizedBox(width: 6),
                        Text(
                          "Informasi Pengguna",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=3",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Udin Slebew",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text("udin.welp@slebew.com"),
                            Text("+62 812 3456 7890"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== Expansion Panels =====
            _buildExpansion("Ketentuan Layanan"),
            const SizedBox(height: 8),
            _buildExpansion("Kebijakan Privasi"),
            const SizedBox(height: 24),

            // ===== Tombol Batalkan =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: const Text(
                  "Batalkan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Widget Helper =====
  Widget _buildRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    double fontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansion(String title) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Vivamus euismod, nisi in cursus commodo, felis urna gravida orci.",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
