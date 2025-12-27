class GymPackageResponse {
  final int code;
  final String status;
  final int recordsTotal;
  final List<GymPackage> data;
  final dynamic errors;

  GymPackageResponse({
    required this.code,
    required this.status,
    required this.recordsTotal,
    required this.data,
    this.errors,
  });

  factory GymPackageResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List?) ?? [];
    return GymPackageResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      recordsTotal: json['recordsTotal'] ?? 0,
      data: list.map((e) => GymPackage.fromJson(e as Map<String, dynamic>)).toList(),
      errors: json['errors'],
    );
  }
}

class GymPackage {
  final int id;
  final String name;
  final String price; // API string
  final int durationDays;
  final int gymId;
  final List<String> benefit;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GymPackage({
    required this.id,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.gymId,
    required this.benefit,
    this.createdAt,
    this.updatedAt,
  });

  factory GymPackage.fromJson(Map<String, dynamic> json) {
    return GymPackage(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? '').toString(),
      durationDays: json['durationDays'] ?? 0,
      gymId: json['gymId'] ?? 0,
      benefit: ((json['benefit'] as List?) ?? []).map((e) => e.toString()).toList(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}
