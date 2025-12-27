import 'package:chain_fit_app/features/dashboard/model/user_model.dart';
import 'package:chain_fit_app/features/dashboard/service/user_profile_service.dart';
import 'package:chain_fit_app/features/formulir_daftar_gym/model/registrant.dart';
import 'package:chain_fit_app/features/gymPreview/page/package_page.dart';
import 'package:flutter/material.dart';

import '../../search_gym/model/search_gym_model.dart';

// import model + service yang baru dibuat

class GymPreviewPage extends StatefulWidget {
  final Gym gym;

  const GymPreviewPage({super.key, required this.gym});

  @override
  State<GymPreviewPage> createState() => _GymPreviewPageState();
}

class _GymPreviewPageState extends State<GymPreviewPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  late final UserProfileService _profileService;
  late final Future<UserProfileData> _futureProfile;

  @override
  void initState() {
    super.initState();

    _profileService = UserProfileService();

    _futureProfile = _profileService.getProfile();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.gym.images.isNotEmpty
        ? widget.gym.images
        : ['https://via.placeholder.com/600'];

    final description = (widget.gym.description.trim().isEmpty)
        ? '-'
        : widget.gym.description;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text("Uget Uget Gym Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== GAMBAR (TIDAK DIUBAH) ======
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

              // ====== CONTAINER 1: NAMA + DESCRIPTION ======
              Container(
                width: double.infinity,
                decoration: _cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.gym.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ====== CONTAINER 2 ======
              Container(
                width: double.infinity,
                decoration: _cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fasilitas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.gym.facilities.isEmpty)
                      Text(
                        "• -",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ...widget.gym.facilities.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          "• $f",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Jam Operasional",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.gym.jamOperasional,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Kapasitas Maks: ${widget.gym.maxCapacity}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Alamat",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.gym.address,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // ====== BUTTON (AMBIL USER DULU) ======
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FutureBuilder<UserProfileData>(
                future: _futureProfile,
                builder: (context, snapshot) {
                  final isLoading =
                      snapshot.connectionState == ConnectionState.waiting;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF636AE8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (snapshot.hasError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Gagal ambil user: ${snapshot.error}",
                                  ),
                                ),
                              );
                              return;
                            }

                            final profile = snapshot.data;
                            if (profile == null) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PackagePage(
                                  gym: widget.gym,
                                  registrant: Registrant.fromAppUser(
                                    profile.user,
                                  ), // <-- user dikirim
                                ),
                              ),
                            );
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Pilih Paket",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
