class Gym {
  final int id;
  final String name;
  final String address;
  final int maxCapacity;
  final String jamOperasional;
  final List<String> facilities;
  final List<String> images;

  Gym({
    required this.id,
    required this.name,
    required this.address,
    required this.maxCapacity,
    required this.jamOperasional,
    required this.facilities,
    required this.images,
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    final List gymImages =
        json['gymImage'] is List ? json['gymImage'] : [];

    return Gym(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      maxCapacity: json['maxCapacity'] is int
          ? json['maxCapacity']
          : int.tryParse('${json['maxCapacity']}') ?? 0,
      jamOperasional: json['jamOperasional']?.toString() ?? '',
      facilities: (json['facility'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      images: gymImages
          .whereType<Map<String, dynamic>>()
          .map((e) => e['url']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList(),
    );
  }
}
