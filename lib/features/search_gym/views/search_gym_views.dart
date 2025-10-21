import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class GymSearchPage extends StatelessWidget {
  const GymSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gyms = [
      {
        'name': 'Laqisya Gym',
        'rating': 4.8,
        'image':
            'https://images.unsplash.com/photo-1579758629938-03607ccdbaba?auto=format&fit=crop&w=800&q=60',
        'address': 'Jl. Sudirman No. 123, Jakarta',
        'distance': '2.5 km',
        'tags': ['Pusat Beban', 'Kelas Yoga', 'Kolam Renang'],
      },
      {
        'name': 'Uget Uget Gym Boyolali 🏋️‍♂️',
        'rating': 4.5,
        'image':
            'https://images.unsplash.com/photo-1554284126-aa88f22d8b74?auto=format&fit=crop&w=800&q=60',
        'address': 'Jl. Aduhai No. 45, Boyolali',
        'distance': '3.1 km',
        'tags': ['Latihan Kardio', 'Pelatih Pribadi', 'Sauna'],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cari Gym',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar — memakai shadcn text field style
            ShadTextField(
              hintText: 'Cari gym...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: gyms.length,
                itemBuilder: (context, index) {
                  final gym = gyms[index];
                  return GymCard(
                    name: gym['name'] as String,
                    rating: gym['rating'] as double,
                    imageUrl: gym['image'] as String,
                    address: gym['address'] as String,
                    distance: gym['distance'] as String,
                    tags: List<String>.from(gym['tags'] as List),
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

class GymCard extends StatelessWidget {
  final String name;
  final double rating;
  final String imageUrl;
  final String address;
  final String distance;
  final List<String> tags;

  const GymCard({
    super.key,
    required this.name,
    required this.rating,
    required this.imageUrl,
    required this.address,
    required this.distance,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      margin: const EdgeInsets.only(bottom: 16),
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 8,
                left: 12,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 4,
                        color: Colors.black45,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 12,
                child: Row(
                  children: [
                    const Icon(Icons.star_border, color: Colors.yellow, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.pink[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        distance,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: -8,
                  children: tags.map((t) {
                    return ShadBadge(
                      label: Text(t, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}