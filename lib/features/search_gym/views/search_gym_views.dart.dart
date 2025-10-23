import 'package:flutter/material.dart';
import '../model/search_gym_model.dart';
import '../widgets/search_gym_input.dart';
import '../widgets/search_gym_card.dart';

class GymSearchPage extends StatelessWidget {
  const GymSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gyms = [
      Gym(
        name: "Laqisya Gym",
        address: "Jl. Sudirman No. 123, Jakarta",
        imageUrl: "https://images.unsplash.com/photo-1554284126-aa88f22d8b74",
        rating: 4.8,
        distance: 2.5,
        tags: ["Pusat Beban", "Kelas Yoga", "Kolam Renang"],
      ),
      Gym(
        name: "Uget Uget Gym Boyolali",
        address: "Jl. Aduhai No. 45, Boyolali",
        imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b",
        rating: 4.5,
        distance: 3.1,
        tags: ["Latihan Kardio", "Pelatih Pribadi", "Sauna"],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Cari Gym"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ShadInput(
              hintText: "Cari gym...",
              prefixIcon: Icons.search,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: gyms.length,
                itemBuilder: (context, index) => GymCard(gym: gyms[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
