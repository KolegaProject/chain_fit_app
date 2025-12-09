import 'package:flutter/material.dart';

class AksesGymPage extends StatelessWidget {
  const AksesGymPage({super.key});

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
            const Text(
              "Pindai untuk Masuk Gym",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // QR Code Container
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(14),
            //   ),
            //   child: Image.asset(
            //     "assets/qr_sample.png", // Ganti dengan QR code-mu
            //     height: 220,
            //   ),
            // ),

            const SizedBox(height: 10),
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
            const Text(
              "#GYM456789",
              style: TextStyle(
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
                onPressed: () {},
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
            Container(
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
                    text:
                        "Pastikan layar ponsel Anda cukup cerah untuk pemindaian yang mudah.",
                  ),
                  SizedBox(height: 12),
                  _TipItem(
                    text:
                        "Jika gagal memindai, coba bersihkan layar ponsel Anda atau perbarui kode QR.",
                  ),
                  SizedBox(height: 12),
                  _TipItem(
                    text:
                        "Untuk bantuan lebih lanjut, hubungi resepsionis gym terdekat.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
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
        const Icon(Icons.lightbulb_outline,
            size: 20, color: Colors.black45),
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
