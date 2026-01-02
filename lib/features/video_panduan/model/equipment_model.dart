class GymEquipment {
  final int id;
  final int gymId;
  final String name;
  final String healthStatus;
  final String? photo;
  final String? videoUrl;
  final String? description;
  final int jumlah;

  GymEquipment({
    required this.id,
    required this.gymId,
    required this.name,
    required this.healthStatus,
    required this.photo,
    required this.videoUrl,
    required this.description,
    required this.jumlah,
  });

  factory GymEquipment.fromJson(Map<String, dynamic> json) {
    return GymEquipment(
      id: json['id'] ?? 0,
      gymId: json['gymId'] ?? 0,
      name: (json['name'] ?? '').toString(),
      healthStatus: (json['healthStatus'] ?? '').toString(),
      photo: json['photo']?.toString(),
      videoUrl: json['videoURL']?.toString(), // sesuai response: videoURL
      description: json['description']?.toString(),
      jumlah: json['jumlah'] ?? 0,
    );
  }
}
