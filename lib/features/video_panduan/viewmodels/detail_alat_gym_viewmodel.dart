import 'package:chain_fit_app/features/video_panduan/model/equipment_model.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailAlatGymViewModel extends ChangeNotifier {
  final GymEquipment item;
  DetailAlatGymViewModel({required this.item});

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _ready = false;
  String? _videoError;

  bool get ready => _ready;
  String? get videoError => _videoError;
  ChewieController? get chewieController => _chewieController;

  bool get hasVideo =>
      (item.videoUrl != null && item.videoUrl!.trim().isNotEmpty);

  bool get isYoutube {
    final url = item.videoUrl?.trim() ?? '';
    final uri = Uri.tryParse(url);
    final host = (uri?.host ?? '').toLowerCase();
    return host.contains('youtube.com') ||
        host.contains('youtu.be') ||
        host.contains('m.youtube.com');
  }

  String? get youtubeId {
    final url = item.videoUrl?.trim() ?? '';
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    final host = uri.host.toLowerCase();

    // youtu.be/<id>
    if (host.contains('youtu.be')) {
      if (uri.pathSegments.isEmpty) return null;
      return uri.pathSegments.first;
    }

    // youtube.com/shorts/<id>
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'shorts') {
      if (uri.pathSegments.length < 2) return null;
      return uri.pathSegments[1];
    }

    // youtube.com/watch?v=<id>
    final v = uri.queryParameters['v'];
    if (v != null && v.isNotEmpty) return v;

    return null;
  }

  /// URL embed untuk WebView
  Uri? get youtubeEmbedUri {
    final id = youtubeId;
    if (id == null || id.trim().isEmpty) return null;
    // playsinline=1 biar ga maksa fullscreen, rel=0 biar ga random video lain
    return Uri.parse(
      'https://www.youtube.com/embed/$id?playsinline=1&rel=0&modestbranding=1',
    );
  }

  Future<void> init() async {
    _ready = false;
    _videoError = null;
    notifyListeners();

    if (!hasVideo) {
      _ready = true;
      notifyListeners();
      return;
    }

    // YouTube: gak perlu init apa-apa, WebView yang handle
    if (isYoutube) {
      if (youtubeEmbedUri == null) {
        _videoError = 'Link YouTube tidak valid';
      }
      _ready = true;
      notifyListeners();
      return;
    }

    // Direct video: mp4/hls -> Chewie
    try {
      final url = item.videoUrl!.trim();
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
      );
    } catch (_) {
      _videoError = 'Video tidak dapat diputar (link bukan mp4/hls)';
    }

    _ready = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}
