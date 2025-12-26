// features/search_gym/widgets/gym_card.dart
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import '../model/search_gym_model.dart';
import 'search_gym_widgets.dart';

class SearchGymCard extends StatelessWidget {
  final Gym gym;
  final VoidCallback? onTap; // <-- tambahkan

  const SearchGymCard({super.key, required this.gym, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // <-- panggil saat ditekan
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: shadcn.Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  gym.images.isNotEmpty
                      ? gym.images.first
                      : 'https://via.placeholder.com/300',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          gym.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            // Text(
                            //   gym.rating.toString(),
                            //   style: const TextStyle(fontSize: 14),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            gym.address,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Badge(
                        //   label: Text("${gym.distance.toStringAsFixed(1)} km"),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Wrap(
                    //   spacing: 6,
                    //   runSpacing: -8,
                    //   children: gym.tags.map((t) => GymBadge(t)).toList(),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ).intrinsic(),
      ),
    );
  }
}
