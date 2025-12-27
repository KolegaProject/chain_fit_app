import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../models/list_qr_model.dart'; // Sesuaikan dengan lokasi file modelmu
import '../../detail_qr/views/detail_qr_view.dart';

class MenuQrPage extends StatefulWidget {
  const MenuQrPage({super.key});

  @override
  State<MenuQrPage> createState() => _MenuQrPageState();
}

class _MenuQrPageState extends State<MenuQrPage> {
  final ApiService _apiService = ApiService();

  // State variables
  List<MembershipModel> _memberships = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMembershipData();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> _fetchMembershipData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _apiService.getMyMemberships();

      setState(() {
        _memberships = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4F5DFF)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text("Menu QR"),
        elevation: 0,
      ),
      // Menggunakan RefreshIndicator agar user bisa tarik layar untuk refresh data
      body: RefreshIndicator(
        onRefresh: _fetchMembershipData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // 1. Tampilan Loading
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Tampilan Error
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                "Gagal memuat data: $_errorMessage",
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: _fetchMembershipData,
                child: const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Tampilan Data Kosong
    if (_memberships.isEmpty) {
      return const Center(child: Text("Tidak ada membership aktif."));
    }

    // 4. Tampilan List Data
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _memberships.length,
      itemBuilder: (context, index) {
        final membership = _memberships[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AksesGymPage(membership: membership), // Kirim data di sini
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
                // Icon kiri
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
                // Isi List
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        membership.gym.name, // Dari Model
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
                              membership.gym.address, // Dari Model
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Tambahan Label Status agar lebih informatif
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: membership.status == "AKTIF"
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
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
        );
      },
    );
  }
}
