import 'package:flutter/material.dart';
import 'detail_video_panduan.dart'; // Pastikan untuk mengimpor halaman detail video

class VideoPanduanPage3 extends StatelessWidget {
  const VideoPanduanPage3({super.key});

  static const List<Map<String, String>> videos = [
    {
      'title': 'Panduan Latihan Efektif',
      'duration': '15 menit',
      'level': 'Pemula',
      'image': 'lib/assets/video_panduan/video_panduan3/satu.png',
    },
    {
      'title': 'Sesi Kardio Intensif',
      'duration': '30 menit',
      'level': 'Menengah',
      'image': 'lib/assets/video_panduan/video_panduan3/dua.png',
    },
    {
      'title': 'Rutinitas Peregangan',
      'duration': '10 menit',
      'level': 'Pemula',
      'image': 'lib/assets/video_panduan/video_panduan3/tiga.png',
    },
    {
      'title': 'Latihan Tubuh Penuh',
      'duration': '45 menit',
      'level': 'Lanjutan',
      'image': 'lib/assets/video_panduan/video_panduan3/empat.png',
    },
    {
      'title': 'Kekuatan Inti: Latihan Dasar',
      'duration': '20 menit',
      'level': 'Menengah',
      'image': 'lib/assets/video_panduan/video_panduan3/lima.png',
    },
    {
      'title': 'Aliran Yoga untuk Relaksasi',
      'duration': '35 menit',
      'level': 'Pemula',
      'image': 'lib/assets/video_panduan/video_panduan3/enam.png',
    },
  ];

  Color getLevelColor(String level) {
    switch (level) {
      case 'Pemula':
        return Colors.green.shade100;
      case 'Menengah':
        return Colors.orange.shade100;
      case 'Lanjutan':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color getTextLevelColor(String level) {
    switch (level) {
      case 'Pemula':
        return Colors.green.shade800;
      case 'Menengah':
        return Colors.orange.shade800;
      case 'Lanjutan':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Video Panduan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: VideoPanduanPage3.videos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // dua kolom
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.82, // tinggi-lebar card
          ),
          itemBuilder: (context, index) {
            final video = VideoPanduanPage3.videos[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoPanduanDetailPage(),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          video['image']!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: Text(
                        video['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            video['duration']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: getLevelColor(video['level']!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              video['level']!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: getTextLevelColor(video['level']!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
