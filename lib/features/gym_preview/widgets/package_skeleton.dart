import 'package:chain_fit_app/core/utils/skeleton.dart';
import 'package:flutter/material.dart';

class PackagePageSkeleton extends StatelessWidget {
  const PackagePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Skeleton(height: 72),
        const SizedBox(height: 16),

        ...List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(height: 140),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
