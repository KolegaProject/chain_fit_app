import 'package:chain_fit_app/features/gym_preview/viewmodels/gym_preview_viewmodel.dart';
import 'package:chain_fit_app/features/gym_preview/views/package_screen.dart';
import 'package:chain_fit_app/features/gym_preview/widgets/gym_image_carousel.dart';
import 'package:chain_fit_app/features/gym_preview/widgets/package_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GymPreviewView extends StatefulWidget {
  final int gymId;
  const GymPreviewView({super.key, required this.gymId});

  @override
  State<GymPreviewView> createState() => _GymPreviewViewState();
}

class _GymPreviewViewState extends State<GymPreviewView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GymPreviewViewModel>().init(widget.gymId);
    });
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
    final vm = context.watch<GymPreviewViewModel>();

    if (vm.showSkeleton) {
      return const PackagePageSkeleton();
    }

    if (vm.errorMessage != null && vm.gym == null) {
      return Scaffold(body: Center(child: Text(vm.errorMessage!)));
    }

    final gym = vm.gym!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: Text(gym.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GymImageCarousel(images: gym.images),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: _cardDecoration(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gym.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    gym.description,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (gym.facilities.isEmpty)
                    Text("• -", style: TextStyle(color: Colors.grey.shade700)),
                  ...gym.facilities.map(
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gym.jamOperasional,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Kapasitas Maks: ${gym.maxCapacity}",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Alamat",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gym.address,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(16),
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
                onPressed: vm.packages.isEmpty || vm.gym == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PackagePage(
                              gymId: vm.gym!.id,
                              gymName: vm.gym!.name,
                              packages: vm.packages,
                            ),
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
