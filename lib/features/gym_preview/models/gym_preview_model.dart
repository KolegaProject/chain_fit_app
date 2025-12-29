class GymPreview {
  final int id;
  final String name;
  final String description;
  final String address;
  final String jamOperasional;
  final int maxCapacity;
  final List<String> facilities;
  final List<String> images;

  GymPreview({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.jamOperasional,
    required this.maxCapacity,
    required this.facilities,
    required this.images,
  });

  factory GymPreview.fromJson(Map<String, dynamic> json) {
    final images = (json['gymImage'] as List? ?? [])
        .map((e) => e['url']?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();

    return GymPreview(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      jamOperasional: json['jamOperasional'] ?? '',
      maxCapacity: json['maxCapacity'] ?? 0,
      facilities:
          (json['facility'] as List? ?? []).map((e) => e.toString()).toList(),
      images: images,
    );
  }
}