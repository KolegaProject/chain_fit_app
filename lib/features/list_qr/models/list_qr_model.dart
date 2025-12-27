class MembershipModel {
  final int id;
  final String startDate;
  final String endDate;
  final String status;
  final GymModel gym;
  final PackageModel package;

  MembershipModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.gym,
    required this.package,
  });

  // Fungsi untuk memetakan JSON ke Object Dart
  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      id: json['id'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      status: json['status'],
      gym: GymModel.fromJson(json['gym']),
      package: PackageModel.fromJson(json['package']),
    );
  }
}

class GymModel {
  final int id;
  final String name;
  final String address;

  GymModel({required this.id, required this.name, required this.address});

  factory GymModel.fromJson(Map<String, dynamic> json) {
    return GymModel(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class PackageModel {
  final int id;
  final String name;
  final String price;
  final int durationDays;

  PackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.durationDays,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price'] ?? '0',
      durationDays: json['durationDays'] ?? 0,
    );
  }
}