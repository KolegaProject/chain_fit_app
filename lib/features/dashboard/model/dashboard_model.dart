class DashboardUser {
  final String name;
  final String profileImageUrl;
  final bool isPremium;
  final String premiumExpiry;
  final int notificationCount;

  DashboardUser({
    required this.name,
    required this.profileImageUrl,
    required this.isPremium,
    required this.premiumExpiry,
    required this.notificationCount,
  });
}

class DashboardMenuItem {
  final String title;
  final String iconAsset;

  DashboardMenuItem({required this.title, required this.iconAsset});
}
