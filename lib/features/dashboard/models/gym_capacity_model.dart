class GymCapacityModel {
  final int maxCapacity;
  final int currentUsers;
  final int availableSpace;
  final String status;

  GymCapacityModel({
    required this.maxCapacity,
    required this.currentUsers,
    required this.availableSpace,
    required this.status,
  });

  factory GymCapacityModel.fromJson(Map<String, dynamic> json) {
    return GymCapacityModel(
      maxCapacity: int.tryParse(json['maxCapacity']?.toString() ?? '') ?? 0,
      currentUsers: int.tryParse(json['currentUsers']?.toString() ?? '') ?? 0,
      availableSpace: int.tryParse(json['availableSpace']?.toString() ?? '') ?? 0,
      status: json['status'] ?? 'UNKNOWN',
    );
  }
}
