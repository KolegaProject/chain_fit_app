class GymSearchItem {
  final int id;
  final String name;
  final String address;
  final String jamOperasional;
  final List<String> images;
  final List<String> facilities;
  final double latitude;
  final double longitude;

  GymSearchItem({
    required this.id,
    required this.name,
    required this.address,
    required this.jamOperasional,
    required this.images,
    required this.facilities,
    required this.latitude,
    required this.longitude,
  });

  factory GymSearchItem.fromJson(Map<String, dynamic> json) {
    final images = (json['gymImage'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => e['url']?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();

    // Parse lat/long safely. If null or invalid, default to 0.0
    // Backend might return strings or numbers
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return GymSearchItem(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      jamOperasional: json['jamOperasional'] ?? '',
      facilities: (json['facility'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      images: images,
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
    );
  }
}
