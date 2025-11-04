import 'package:flutter/material.dart';

import 'video_panduan3.dart';

class VideoPanduanPage2 extends StatelessWidget {
  const VideoPanduanPage2({super.key});

  final List<Map<String, String>> videos = const [
    {
      'title': 'Latihan Kardio Intensif',
      'description': 'Tingkatkan detak jantung Anda',
      'image': 'lib/assets/video_panduan/video_panduan2/satu.png',
    },
    {
      'title': 'Panduan Kekuatan Penuh Tubuh',
      'description': 'Bangun otot dan tingkatkan kekuatan',
      'image': 'lib/assets/video_panduan/video_panduan2/dua.png',
    },
    {
      'title': 'Yoga untuk Fleksibilitas &',
      'description': 'Sempurnakan postur dan fleksibilitas',
      'image': 'lib/assets/video_panduan/video_panduan2/tiga.png',
    },
    {
      'title': 'HIIT: Pembakar Lemak Cepat',
      'description': 'Sesi latihan interval intensitas tinggi',
      'image': 'lib/assets/video_panduan/video_panduan2/empat.png',
    },
    {
      'title': 'Pilates untuk Penguatan Inti',
      'description': 'Fokus pada kekuatan inti dan keseimbangan',
      'image': 'lib/assets/video_panduan/video_panduan2/lima.png',
    },
    {
      'title': 'Rutinitas Peregangan Pagi',
      'description': 'Mulai hari Anda dengan peregangan ringan',
      'image': 'lib/assets/video_panduan/video_panduan2/enam.png',
    },
  ];

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
          itemCount: videos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // dua kolom
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78, // rasio tinggi-lebar
          ),
          itemBuilder: (context, index) {
            final video = videos[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoPanduanPage3(),
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
                          decoration: BoxDecoration(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        video['description']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
