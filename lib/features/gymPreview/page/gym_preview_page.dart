import 'package:chain_fit_app/features/formulir_daftar_gym/views/formulir_daftar_gym_view.dart';
import 'package:flutter/material.dart';

// pakai model Gym kamu
import '../../search_gym/model/search_gym_model.dart';

class GymPreviewPage extends StatefulWidget {
  final Gym gym;

  const GymPreviewPage({super.key, required this.gym});

  @override
  State<GymPreviewPage> createState() => _GymPreviewPageState();
}

class _GymPreviewPageState extends State<GymPreviewPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ sesuai model: images
    final images = widget.gym.images.isNotEmpty
        ? widget.gym.images
        : ['https://via.placeholder.com/600'];

    return Scaffold(
      appBar: AppBar(title: const Text("Uget Uget Gym Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (_, __, ___) => const SizedBox(
                              height: 220,
                              child: Center(child: Icon(Icons.broken_image)),
                            ),
                          );
                        },
                      ),
                    ),

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
                            if (_currentPage < images.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 10 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
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
                widget.gym.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text("Jam Operasional: ${widget.gym.jamOperasional}"),
              const SizedBox(height: 6),
              Text("Kapasitas Maks: ${widget.gym.maxCapacity}"),

              const SizedBox(height: 16),
              const Text(
                "Fasilitas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              // ✅ sesuai model: facilities
              if (widget.gym.facilities.isEmpty) const Text("• -"),
              ...widget.gym.facilities.map((f) => Text("• $f")),

              const SizedBox(height: 20),
              const Text(
                "Alamat:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.gym.address),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => PendaftaranGymPage(gym: widget.gym),
                  //   ),
                  // );
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
