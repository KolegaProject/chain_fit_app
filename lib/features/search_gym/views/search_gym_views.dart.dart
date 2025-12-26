// features/search_gym/views/search_gym_page.dart
import 'package:flutter/material.dart';
import '../model/search_gym_model.dart';
import '../service/gym_service.dart';
import '../widgets/search_gym_card.dart';
import '../widgets/search_gym_input.dart';

class SearchGymView extends StatefulWidget {
  final String accessToken; // ⛔ jangan disentuh

  const SearchGymView({required this.accessToken, Key? key}) : super(key: key);

  @override
  State<SearchGymView> createState() => _SearchGymViewState();
}

class _SearchGymViewState extends State<SearchGymView> {
  final GymService _gymService = GymService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Gym>> _gymsFuture;

  @override
  void initState() {
    super.initState();
    // 🔥 search WAJIB ADA walau kosong
    _gymsFuture = _gymService.searchGyms(query: '');
  }

  void _onSearch(String value) {
    setState(() {
      _gymsFuture = _gymService.searchGyms(query: value);
    });
  }

  void _retry() {
    setState(() {
      _gymsFuture = _gymService.searchGyms(query: _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Gym'), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchGymInput(
              controller: _searchController,
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Gym>>(
              future: _gymsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 50,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _retry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final gyms = snapshot.data;
                if (gyms == null || gyms.isEmpty) {
                  return const Center(child: Text('Tidak ada gym ditemukan'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: gyms.length,
                  itemBuilder: (context, index) {
                    return SearchGymCard(gym: gyms[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
