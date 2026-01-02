import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/equipment_model.dart';

class DetailAlatGymViewModel extends ChangeNotifier {
  final GymEquipment item;
  DetailAlatGymViewModel({required this.item});

  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _ready = false;
  String? _videoError;

  // ================= GETTERS =================
  GymEquipment get equipment => item;
  bool get ready => _ready;
  String? get videoError => _videoError;

  YoutubePlayerController? get youtubeController => _youtubeController;
  ChewieController? get chewieController => _chewieController;

  bool get hasVideo =>
      item.videoUrl != null && item.videoUrl!.trim().isNotEmpty;

  bool get isYoutube =>
      YoutubePlayer.convertUrlToId(item.videoUrl ?? '') != null;

  String? get youtubeId =>
      YoutubePlayer.convertUrlToId(item.videoUrl ?? '');

  // ================= INIT =================
  Future<void> init() async {
    _ready = false;
    _videoError = null;
    notifyListeners();

    if (!hasVideo) {
      _ready = true;
      notifyListeners();
      return;
    }

    // ===== YOUTUBE =====
    if (isYoutube) {
      final id = youtubeId;
      if (id == null) {
        _videoError = 'Link YouTube tidak valid';
      } else {
        _youtubeController = YoutubePlayerController(
          initialVideoId: id,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        );
      }

      _ready = true;
      notifyListeners();
      return;
    }

    // ===== MP4 / HLS =====
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(item.videoUrl!.trim()),
      );
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
      );
    } catch (_) {
      _videoError = 'Video tidak dapat diputar';
    }

    _ready = true;
    notifyListeners();
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    _youtubeController?.dispose();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}
