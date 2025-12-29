class GymPackage {
  final int id;
  final String name;
  final String price;
  final int durationDays;
  final List<String> benefit;

  GymPackage({
    required this.id,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.benefit,
  });

  factory GymPackage.fromJson(Map<String, dynamic> json) {
    return GymPackage(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price'].toString(),
      durationDays: json['durationDays'] ?? 0,
      benefit:
          (json['benefit'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}