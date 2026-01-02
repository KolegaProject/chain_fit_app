import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/equipment_model.dart';
import '../viewmodels/detail_alat_gym_viewmodel.dart';

class DetailAlatGymPage extends StatelessWidget {
  final GymEquipment item;
  const DetailAlatGymPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailAlatGymViewModel(item: item)..init(),
      child: const _DetailAlatGymView(),
    );
  }
}

class _DetailAlatGymView extends StatelessWidget {
  const _DetailAlatGymView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailAlatGymViewModel>();
    final item = vm.equipment;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          item.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildMedia(vm),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                (item.description == null || item.description!.trim().isEmpty)
                    ? '-'
                    : item.description!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MEDIA =================
  Widget _buildMedia(DetailAlatGymViewModel vm) {
    final item = vm.equipment;

    if (!vm.ready) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.hasVideo) {
      // ===== YOUTUBE =====
      if (vm.isYoutube && vm.youtubeController != null) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(
            controller: vm.youtubeController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
          ),
        );
      }

      // ===== MP4 / HLS =====
      if (vm.chewieController != null) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(controller: vm.chewieController!),
        );
      }

      return const SizedBox(
        height: 220,
        child: Center(child: Text('Video tidak dapat diputar')),
      );
    }

    // ===== FOTO =====
    final photo = item.photo;
    if (photo == null || photo.trim().isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Icon(Icons.image_not_supported, size: 48)),
      );
    }

    return Image.network(
      photo,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
