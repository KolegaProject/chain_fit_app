import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:chain_fit_app/features/video_panduan/model/detail_video_panduan_model.dart';

class DetailAlatGymPage extends StatefulWidget {
  final DetailAlatGymModel item;

  const DetailAlatGymPage({
    super.key,
    required this.item,
  });

  @override
  State<DetailAlatGymPage> createState() => _DetailAlatGymPageState();
}

class _DetailAlatGymPageState extends State<DetailAlatGymPage> {
  VideoPlayerController? videoController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();

    if (widget.item.videoUrl != null && widget.item.videoUrl!.isNotEmpty) {
      videoController = VideoPlayerController.network(widget.item.videoUrl!)
        ..initialize().then((_) {
          chewieController = ChewieController(
            videoPlayerController: videoController!,
            autoPlay: false,
            looping: false,
          );
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = widget.item.videoUrl != null && widget.item.videoUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.item.title,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                child: hasVideo
                    ? (chewieController != null
                        ? Chewie(controller: chewieController!)
                        : SizedBox(
                            height: 220,
                            child: const Center(child: CircularProgressIndicator()),
                          ))
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            widget.item.imagePath,
                            fit: BoxFit.contain,
                            height: 220,
                            width: double.infinity,
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF6366F1),
                            ),
                            child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                          ),
                        ],
                      ),
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
                widget.item.description,
                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
