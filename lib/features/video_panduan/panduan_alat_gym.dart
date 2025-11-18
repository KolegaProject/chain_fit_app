import 'package:flutter/material.dart';
import 'detail_video_panduan.dart';

class PanduanAlatGymPage extends StatefulWidget {
  const PanduanAlatGymPage({super.key});

  @override
  State<PanduanAlatGymPage> createState() => _PanduanAlatGymPageState();
}

class _PanduanAlatGymPageState extends State<PanduanAlatGymPage> {
  final TextEditingController _searchController = TextEditingController();
  String query = '';

  final List<Map<String, String>> alatGym = [
    {
      'name': 'Cable Crossover',
      'image': 'lib/assets/video_panduan/satu.jpeg',
      'description':
      'Cable Crossover adalah alat gym yang digunakan untuk melatih otot dada, terutama bagian tengah dan luar. Gerakan ini juga melibatkan otot bahu dan trisep. Pastikan untuk menjaga postur tubuh tetap stabil dan gunakan beban yang sesuai untuk menghindari cedera.',
    },
    {
      'name': 'Leg Press',
      'image': 'lib/assets/video_panduan/dua.jpeg',
      'description':
      'Leg Press adalah alat yang dirancang untuk melatih otot paha depan (quadriceps), paha belakang (hamstring), dan gluteus. Posisi kaki pada platform dapat disesuaikan untuk menargetkan area tertentu. Hindari mengunci lutut saat mendorong beban untuk mencegah cedera.',
    },
    {
      'name': 'Leg Curl',
      'image': 'lib/assets/video_panduan/tiga.jpeg',
      'description':
      'Leg Curl digunakan untuk melatih otot hamstring (paha belakang). Gerakan ini membantu meningkatkan kekuatan dan fleksibilitas otot paha belakang. Pastikan untuk melakukan gerakan dengan kontrol penuh dan hindari menggunakan beban yang terlalu berat.',
    },
    {
      'name': 'Parallel Bar',
      'image': 'lib/assets/video_panduan/empat.jpeg',
      'description':
      'Parallel Bar adalah alat yang digunakan untuk latihan dips, yang melatih otot dada, trisep, dan bahu. Gerakan ini dapat dilakukan dengan mencondongkan tubuh ke depan untuk fokus pada dada atau menjaga tubuh tegak untuk fokus pada trisep.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = alatGym
        .where((item) => item['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Panduan Alat Gym',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                hintText: 'Cari alat gym...',
                prefixIcon: const Icon(Icons.search),
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailAlatGymPage(
                            title: item['name'] ?? '',
                            imagePath: item['image'] ?? '',
                            description: item['description'] ?? '',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                item['image']!,
                                fit: BoxFit.contain, 
                              ),
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
