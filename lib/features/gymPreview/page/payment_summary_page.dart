import 'package:chain_fit_app/features/formulir_daftar_gym/model/registrant.dart';
import 'package:flutter/material.dart';
import '../model/gym_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> requestNotificationPermission() async {
  final plugin = FlutterLocalNotificationsPlugin();
  final androidImplementation = plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  await androidImplementation?.requestNotificationsPermission();
}

Future<void> showPaymentSuccessNotification() async {
  await requestNotificationPermission();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'payment_channel',
        'Pembayaran',
        channelDescription: 'Notifikasi pembayaran sukses',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'Pembayaran Berhasil',
    'Terima kasih, pembayaran Anda telah sukses!',
    platformChannelSpecifics,
  );
}

const String kTosText = '''
Tanggal Berlaku: 12 November 2025

1. Penerimaan Syarat
Dengan membuat akun atau menggunakan layanan, Anda menyetujui Ketentuan Layanan ini serta kebijakan terkait yang berlaku.

2. Deskripsi Layanan
Aplikasi menyediakan pendaftaran member gym, pengelolaan paket, dan pembayaran melalui mitra pembayaran pihak ketiga.

3. Akun & Keamanan
- Anda wajib memberi informasi yang akurat dan mutakhir.
- Jaga kredensial Anda; aktivitas pada akun menjadi tanggung jawab Anda.
- Laporkan akses tidak sah ke dukungan kami.

4. Pembayaran & Biaya
- Harga paket ditampilkan sebelum pembayaran; pajak/biaya admin dapat berlaku.
- Transaksi diproses oleh penyedia pembayaran pihak ketiga.
- Pembatalan/refund mengikuti kebijakan Refund (lihat poin 7).

5. Penggunaan yang Dilarang
Dilarang: penyalahgunaan, penipuan, pelanggaran hukum/hak pihak ketiga, reverse engineering, atau gangguan terhadap layanan.

6. Ketersediaan & Perubahan Layanan
Kami dapat memperbarui, membatasi, atau menghentikan fitur kapan saja dengan atau tanpa pemberitahuan, sejauh diizinkan hukum.

7. Refund & Pembatalan
- Refund hanya berlaku jika memenuhi kriteria (mis. pembayaran ganda, kegagalan layanan).
- Permohonan refund diajukan dalam 7 hari dengan bukti pembayaran.

8. Batasan Tanggung Jawab
Layanan disediakan “sebagaimana adanya”. Kami tidak bertanggung jawab atas kerugian tidak langsung, insidental, atau konsekuensial.

9. Hak Kekayaan Intelektual
Seluruh materi (merek, logo, konten, kode) dilindungi hukum. Anda tidak memperoleh hak selain yang diizinkan tertulis.

10. Hukum yang Berlaku & Sengketa
Diatur oleh hukum Republik Indonesia. Sengketa diselesaikan terlebih dahulu secara musyawarah; bila gagal, melalui mekanisme yang berlaku.

11. Kontak
Email: support@yourcompany.com
''';

const String kPrivacyText = '''
Tanggal Berlaku: 12 November 2025

1. Ringkasan
Kami mengumpulkan data untuk mengoperasikan layanan (pendaftaran, pembayaran, dukungan). Kami menjaga data sesuai peraturan yang berlaku.

2. Data yang Dikumpulkan
- Data Identitas: nama, email, telepon.
- Data Transaksi: paket, harga, metode pembayaran, status.
- Data Teknis: perangkat, log, alamat IP secara terbatas.
- Data Komunikasi: pertanyaan/keluhan yang Anda kirimkan.

3. Cara Penggunaan Data
- Menyediakan dan meningkatkan layanan.
- Memproses pembayaran dan mencegah kecurangan.
- Mengirim notifikasi terkait transaksi/akun.
- Kepatuhan hukum dan audit.

4. Dasar Pemrosesan
- Persetujuan Anda.
- Pelaksanaan kontrak (penyediaan layanan).
- Kepentingan sah (keamanan, peningkatan layanan).
- Kewajiban hukum.

5. Berbagi Data
- Mitra pembayaran dan penyedia infrastruktur.
- Pihak berwenang bila diwajibkan hukum.
- Tidak menjual data pribadi Anda.

6. Keamanan
Kami menerapkan kontrol teknis dan organisasional yang wajar untuk melindungi data. Namun, tidak ada sistem yang 100% aman.

7. Retensi
Data disimpan selama akun aktif atau sesuai kebutuhan bisnis/ hukum. Data transaksi dapat disimpan lebih lama untuk kepatuhan.

8. Hak Pengguna
Anda dapat meminta akses, koreksi, penghapusan, pembatasan, atau portabilitas data sejauh diizinkan. Hubungi kami melalui email dukungan.

9. Cookie & Pelacakan
Kami dapat menggunakan cookie/ID perangkat untuk fungsionalitas dan analitik. Anda dapat mengelola preferensi melalui pengaturan perangkat/aplikasi.

10. Transfer Internasional
Jika data dipindahkan ke luar negeri, kami akan memastikan perlindungan yang memadai sesuai regulasi.

11. Perubahan Kebijakan
Kami dapat memperbarui kebijakan ini. Versi terbaru akan ditampilkan di aplikasi.

12. Kontak
Email: privacy@yourcompany.com
''';

class PaymentSummaryPage extends StatefulWidget {
  final Package pkg;
  final String method;
  final Registrant registrant;

  const PaymentSummaryPage({
    super.key,
    required this.pkg,
    required this.method,
    required this.registrant,
  });

  @override
  State<PaymentSummaryPage> createState() => _PaymentSummaryPageState();
}

class _PaymentSummaryPageState extends State<PaymentSummaryPage> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    requestNotificationPermission();
  }

  Future<bool?> _showCancelConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded),
              SizedBox(width: 8),
              Text("Konfirmasi"),
            ],
          ),
          content: const Text(
            "Apakah Anda yakin ingin keluar?\n"
            "Semua langkah/isi yang sudah Anda masukkan akan hilang.",
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Ya, keluar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text("Tidak, kembali"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Inisialisasi notifikasi saat widget pertama kali build
    initializeNotifications();
    int discount = 50000;
    int adminFee = 10000;
    int total = widget.pkg.price - discount + adminFee;

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
                    _buildRow("Paket", widget.pkg.name),
                    _buildRow("Harga", "Rp ${widget.pkg.price}"),
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
                    _buildRow("Metode Pembayaran", widget.method),
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

            // informasi pengguna
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
                          children: [
                            Text(
                              widget.registrant.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(widget.registrant.email),
                            Text(widget.registrant.phone),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // expansion panels
            _buildExpansion("Ketentuan Layanan", kTosText),
            const SizedBox(height: 8),
            _buildExpansion("Kebijakan Privasi", kPrivacyText),
            const SizedBox(height: 24),

            // tombol batalkan
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
                onPressed: () async {
                  final ok = await _showCancelConfirm(context);
                  if (ok == true) {
                    if (context.mounted) {
                      Navigator.popUntil(context, (r) => r.isFirst);
                    }
                  }
                },
                child: const Text(
                  "Batalkan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 12),
            // tombol pembayaran selesai
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  await showPaymentSuccessNotification();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pembayaran berhasil! Notifikasi dikirim.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Pembayaran Selesai",
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

  Widget _buildExpansion(String title, String content) {
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
            child: SelectableText(
              content,
              style: const TextStyle(color: Colors.grey, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
