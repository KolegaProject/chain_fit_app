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
      // Sesuaikan key ini dengan response Postman kalau beda
      gymName: json['gym_name'] ?? 'Unknown Gym',
      type: json['package_name'] ?? 'Regular Member',
      startDate: DateTime.parse(
        json['start_date'] ?? DateTime.now().toString(),
      ),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toString()),
      // Anggap status 'active' berarti true
      isActive: json['status'] == 'active',
    );
  }
}
