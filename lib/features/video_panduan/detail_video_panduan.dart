import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6200EE);
const Color accentColor = Color(0xFF03DAC6);

class VideoDetail {
  final String title;
  final String description;
  final String duration;
  final String level;
  final String videoUrl;
  final String imageUrl;

  const VideoDetail({
    required this.title,
    required this.description,
    required this.duration,
    required this.level,
    required this.videoUrl,
    required this.imageUrl,
  });
}

class VideoPanduanDetailPage extends StatelessWidget {
  const VideoPanduanDetailPage({super.key});

  final VideoDetail data = const VideoDetail(
    title: "Latihan Kebugaran Seluruh Tubuh untuk Pemula",
    description:
    "Panduan komprehensif ini dirancang untuk pemula yang ingin membangun kekuatan dan stamina di seluruh tubuh. "
        "Ikuti instruktur kami yang berpengalaman melalui serangkaian latihan yang aman dan efektif. "
        "Latihan ini berfokus pada bentuk yang tepat dan progres bertahap, menjadikannya awal yang sempurna untuk perjalanan kebugaran Anda.",
    duration: "30 Menit",
    level: "Pemula",
    videoUrl: "URL_VIDEO_ANDA",
    imageUrl: "lib/assets/video_panduan/detail_video_panduan/satu.png",
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(
                  data.title,
                  style: const TextStyle(fontSize: 16),
                ),
                floating: true,
                pinned: true,
                snap: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                centerTitle: false,
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.notifications_none, color: Colors.black),
                  ),
                ],
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          data.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_arrow,
                              size: 48,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Memutar Video... (Implementasi Video Player)',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const TabBar(
                    labelColor: primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: primaryColor,
                    tabs: [
                      Tab(text: "Gambaran Umum"),
                      Tab(text: "Instruksi"),
                      Tab(text: "Video Terkait"),
                    ],
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ];
          },

          body: TabBarView(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GambaranUmumContent(data: data),
              ),

              const Center(
                child: Text("Isi untuk Instruksi (List Langkah-langkah)"),
              ),

              const Center(
                child: Text("Isi untuk Video Terkait (List Video)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GambaranUmumContent extends StatelessWidget {
  final VideoDetail data;

  const GambaranUmumContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Text(
          data.description,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  data.duration,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Row(
              children: [
                const Icon(Icons.bolt, size: 20, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  data.level,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

