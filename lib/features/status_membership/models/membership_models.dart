class Membership {
  final String gymName;
  final String type; // Nama Paket
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  Membership({
    required this.gymName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  // Getter untuk menghitung sisa hari secara otomatis
  int get sisaHari {
    final now = DateTime.now();
    // Menghitung selisih hari antara hari ini dan tanggal berakhir
    final difference = endDate.difference(now).inDays;
    return difference < 0 ? 0 : difference;
  }

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      gymName: json['gym']?['name'] ?? 'Unknown Gym',
      type: json['package']?['name'] ?? 'Regular Member',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      isActive: json['status'] == 'AKTIF',
    );
  }
}
