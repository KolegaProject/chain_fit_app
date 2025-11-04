import 'package:flutter/material.dart';

import 'video_panduan2.dart';

class VideoPanduanPage1 extends StatelessWidget {
  const VideoPanduanPage1({super.key});

  static const List<Map<String, String>> videos = [
    {
      'title': 'Latihan Kekuatan Penuh Tubuh untuk Pemula',
      'duration': '30 menit',
      'image': 'lib/assets/video_panduan/video_panduan1/satu.png',
    },
    {
      'title': '10 Menit HIIT untuk Pembakar Lemak Cepat',
      'duration': '15 menit',
      'image': 'lib/assets/video_panduan/video_panduan1/dua.png',
    },
    {
      'title': 'Peregangan Esensial untuk Fleksibilitas',
      'duration': '20 menit',
      'image': 'lib/assets/video_panduan/video_panduan1/tiga.png',
    },
    {
      'title': 'Master Pull-Up: Panduan Langkah-demi-Langkah',
      'duration': '12 menit',
      'image': 'lib/assets/video_panduan/video_panduan1/empat.png',
    },
    {
      'title': 'Cardio Intensif untuk Daya Tahan Jantung',
      'duration': '45 menit',
      'image': 'lib/assets/video_panduan/video_panduan1/lima.png',
    },
    {
      'title': 'Pengenalan Latihan Kettlebell untuk Kekuatan',
      'duration': '25 menit',
      'image': 'lib/assets/video_panduan/video_panduan1/enam.png',
    },
    {
      'title': 'Dasar-Dasar Tinju: Bentuk dan Kombinasi',
      'duration': '18 menit',
      'image': 'lib/assets/video_panduan/video_panduan1/tujuh.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Video Panduan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: VideoPanduanPage1.videos.length,
        itemBuilder: (context, index) {
          final video = VideoPanduanPage1.videos[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    video['image']!,
                    width: 80,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  video['title']!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Durasi: ${video['duration']}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoPanduanPage2(),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
