import 'package:chain_fit_app/features/video_panduan/model/equipment_model.dart';
import 'package:chain_fit_app/features/video_panduan/view/detail_video_panduan_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/panduan_alat_gym_viewmodel.dart';

class PanduanAlatGymPage extends StatelessWidget {
  const PanduanAlatGymPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PanduanAlatGymViewModel()..init(),
      child: const _PanduanAlatGymView(),
    );
  }
}

class _PanduanAlatGymView extends StatefulWidget {
  const _PanduanAlatGymView();

  @override
  State<_PanduanAlatGymView> createState() => _PanduanAlatGymViewState();
}

class _PanduanAlatGymViewState extends State<_PanduanAlatGymView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PanduanAlatGymViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Panduan Alat Gym",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (v) => vm.query = v,
              decoration: InputDecoration(
                hintText: 'Cari alat gym...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Builder(
                builder: (_) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(vm.errorMessage!, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: vm.retry,
                            child: const Text('Coba lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  final list = vm.filteredItems;
                  if (list.isEmpty) {
                    return const Center(child: Text('Data tidak ditemukan'));
                  }

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final GymEquipment item = list[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailAlatGymPage(item: item),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF6366F1), width: 2),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: _EquipmentImage(photoUrl: item.photo),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 12),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6366F1).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EquipmentImage extends StatelessWidget {
  final String? photoUrl;
  const _EquipmentImage({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;
    if (!hasPhoto) {
      return Container(
        height: 200,
        width: double.infinity,
        alignment: Alignment.center,
        color: Colors.grey.shade100,
        child: const Icon(Icons.image_not_supported, size: 48),
      );
    }

    return Image.network(
      photoUrl!,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 200,
        width: double.infinity,
        alignment: Alignment.center,
        color: Colors.grey.shade100,
        child: const Icon(Icons.broken_image, size: 48),
      ),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
