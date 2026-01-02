import 'package:chain_fit_app/features/video_panduan/model/equipment_model.dart';
import 'package:chain_fit_app/features/video_panduan/viewmodels/detail_alat_gym_viewmodel.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    final item = vm.item;

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

  Widget _buildMedia(DetailAlatGymViewModel vm) {
    final item = vm.item;

    if (!vm.ready) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.hasVideo) {
      // ===== YouTube in-app via WebView =====
      if (vm.isYoutube) {
        final uri = vm.youtubeEmbedUri;
        if (uri == null) {
          return SizedBox(
            height: 220,
            child: Center(
              child: Text(vm.videoError ?? 'Link YouTube tidak valid'),
            ),
          );
        }
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: _YoutubeWebView(url: uri),
        );
      }

      // ===== mp4/hls via Chewie =====
      if (vm.chewieController != null) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(controller: vm.chewieController!),
        );
      }

      return SizedBox(
        height: 220,
        child: Center(
          child: Text(vm.videoError ?? 'Video tidak dapat diputar'),
        ),
      );
    }

    // ===== Foto =====
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

class _YoutubeWebView extends StatefulWidget {
  final Uri url;
  const _YoutubeWebView({required this.url});

  @override
  State<_YoutubeWebView> createState() => _YoutubeWebViewState();
}

class _YoutubeWebViewState extends State<_YoutubeWebView> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (_) => setState(() => _loading = false),
        ),
      )
      ..loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
