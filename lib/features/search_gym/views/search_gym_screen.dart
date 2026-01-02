import 'package:chain_fit_app/features/gym_preview/views/gym_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/search_gym_viewmodel.dart';
import '../widgets/search_gym_card.dart';
import '../widgets/search_gym_input.dart';

class SearchGymView extends StatefulWidget {
  const SearchGymView({super.key});

  @override
  State<SearchGymView> createState() => _SearchGymViewState();
}

class _SearchGymViewState extends State<SearchGymView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchGymViewModel>().search();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchGymViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Gym')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchGymInput(
              controller: _searchController,
              onChanged: (value) {
                vm.search(query: value);
              },
            ),
          ),
          Expanded(child: _buildBody(vm)),
        ],
      ),
    );
  }

  Widget _buildBody(SearchGymViewModel vm) {
    if (vm.showFullScreenLoader) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.showFullScreenError) {
      return Center(child: Text(vm.errorMessage!));
    }

    if (vm.gyms.isEmpty) {
      return const Center(child: Text('Tidak ada gym ditemukan'));
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vm.gyms.length,
          itemBuilder: (_, index) {
            final gym = vm.gyms[index];
            return SearchGymCard(
              gym: gym,
              userPosition: vm.userLocation,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GymPreviewView(gymId: gym.id),
                  ),
                );
              },
            );
          },
        ),
        if (vm.showRefetchingIndicator)
          const LinearProgressIndicator(minHeight: 2),
      ],
    );
  }
}
