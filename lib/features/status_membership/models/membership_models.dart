class Membership {
  final String gymName;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final int sisaHari;
  final bool isActive;

  Membership({
    required this.gymName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.sisaHari,
    required this.isActive,
  });
}
