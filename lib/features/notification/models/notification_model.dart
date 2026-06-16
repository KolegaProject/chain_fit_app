class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });

  // Dummy list data
  static List<NotificationModel> get dummyData => [
    NotificationModel(
      id: "1",
      title: "Selamat Datang!",
      message: "Terima kasih sudah bergabung dengan Chain Fit.",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: "2",
      title: "Promo Spesial",
      message: "Dapatkan diskon 50% untuk member baru bulan ini.",
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: "3",
      title: "Tips Latihan",
      message: "Jangan lupa pemanasan sebelum angkat beban berat!",
      date: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];
}
