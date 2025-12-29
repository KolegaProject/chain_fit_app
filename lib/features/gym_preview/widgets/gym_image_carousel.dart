import 'package:flutter/material.dart';

class GymImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;

  const GymImageCarousel({
    super.key,
    required this.images,
    this.height = 220,
  });

  @override
  State<GymImageCarousel> createState() => _GymImageCarouselState();
}

class _GymImageCarouselState extends State<GymImageCarousel> {
  int _currentIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images.isNotEmpty
        ? widget.images
        : ['https://via.placeholder.com/600'];

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _controller,
              itemCount: images.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (_, i) {
                return Image.network(
                  images[i],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (_, child, loading) {
                    if (loading == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                );
              },
            ),
          ),

          // indicator
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == i ? 10 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      _currentIndex == i ? 1 : 0.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}