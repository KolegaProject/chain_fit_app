import 'dart:convert';
import 'package:chain_fit_app/features/formulir_daftar_gym/views/formulir_daftar_gym_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/gym_model.dart';
import 'package_page.dart';

class GymPreviewPage extends StatefulWidget {
  final String gymName;
  final List<String> gymImages;

  const GymPreviewPage({
    super.key,
    required this.gymName,
    required this.gymImages,
  });

  @override
  State<GymPreviewPage> createState() => _GymPreviewPageState();
}

class _GymPreviewPageState extends State<GymPreviewPage> {
  Gym? gymData;
  int _currentPage = 0; // untuk indikator
  final PageController _pageController = PageController();
  late List<String> gymImages;

  @override
  void initState() {
    super.initState();
    gymImages = widget.gymImages;
    loadGymData();
  }

  Future<void> loadGymData() async {
    final data = await rootBundle.loadString(
      'lib/features/gymPreview/data.json',
    );
    final jsonResult = jsonDecode(data);
    setState(() {
      gymData = Gym.fromJson(jsonResult[widget.gymName]);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gymData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Uget Uget Gym Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Carousel Section ===
              // === Carousel Section ===
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: gymImages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.asset(
                            gymImages[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                    ),

                    // === Panah kiri ===
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 8,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            if (_currentPage > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    // === Panah kanan ===
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 8,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            if (_currentPage < gymImages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    // === Indikator titik di bawah ===
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          gymImages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 10 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                gymData!.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(gymData!.description),
              const SizedBox(height: 16),
              const Text(
                "Fasilitas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...gymData!.facilities.map((f) => Text("• $f")),
              const SizedBox(height: 20),
              const Text(
                "Alamat:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(gymData!.location),
              const SizedBox(height: 80), // ruang untuk tombol bawah
            ],
          ),
        ),
      ),

      // Tombol tetap di bawah seperti ShadCN style
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF636AE8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (_) => PackagePage(gym: gymData!),
                      builder: (_) => PendaftaranGymPage(gym: gymData!),
                    ),
                  );
                },
                child: const Text(
                  "Pilih Paket",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
