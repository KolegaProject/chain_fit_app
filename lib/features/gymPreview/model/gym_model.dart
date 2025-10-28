class Gym {
  final String name;
  final String location;
  final String description;
  final List<String> facilities;
  final List<Package> packages;

  Gym({
    required this.name,
    required this.location,
    required this.description,
    required this.facilities,
    required this.packages,
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      name: json['name'],
      location: json['location'],
      description: json['description'],
      facilities: List<String>.from(json['facilities']),
      packages: (json['packages'] as List)
          .map((p) => Package.fromJson(p))
          .toList(),
    );
  }
}

class Package {
  final String name;
  final int price;
  final String duration;
  final List<String> features;
  final bool popular;

  Package({
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    this.popular = false,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json['name'],
      price: json['price'],
      duration: json['duration'],
      features: List<String>.from(json['features']),
      popular: json['popular'] ?? false,
    );
  }
}
