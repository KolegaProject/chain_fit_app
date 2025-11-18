class DetailAlatGymModel {
  final String title;
  final String imagePath;
  final String description;

  const DetailAlatGymModel({
    required this.title,
    required this.imagePath,
    required this.description,
  });

  factory DetailAlatGymModel.fromPanduanModel(Map<String, String> m) =>
      DetailAlatGymModel(
        title: m['name'] ?? '',
        imagePath: m['image'] ?? '',
        description: m['description'] ?? '',
      );
}

