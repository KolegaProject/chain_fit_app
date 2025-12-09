class Gym {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final double distance;
  final List<String> tags;
  final List<String> images;

  Gym({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.tags,
    required this.images,
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
