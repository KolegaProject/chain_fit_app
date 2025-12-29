class GymSearchItem {
  final int id;
  final String name;
  final String address;
  final String jamOperasional;
  final List<String> images;
  final List<String> facilities;

  GymSearchItem({
    required this.id,
    required this.name,
    required this.address,
    required this.jamOperasional,
    required this.images,
    required this.facilities,
  });

  factory GymSearchItem.fromJson(Map<String, dynamic> json) {
    final images = (json['gymImage'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => e['url']?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();

    return GymSearchItem(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      jamOperasional: json['jamOperasional'] ?? '',
      facilities:
          (json['facility'] as List? ?? []).map((e) => e.toString()).toList(),
      images: images,
    );
  }
}