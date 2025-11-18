class PanduanAlatGymModel {
  final String name;
  final String image;
  final String description;

  const PanduanAlatGymModel({
    required this.name,
    required this.image,
    required this.description,
  });

  factory PanduanAlatGymModel.fromMap(Map<String, String> m) => PanduanAlatGymModel(
        name: m['name'] ?? '',
        image: m['image'] ?? '',
        description: m['description'] ?? '',
      );

  Map<String, String> toMap() => {
        'name': name,
        'image': image,
        'description': description,
      };

  static final List<PanduanAlatGymModel> samples = [
    const PanduanAlatGymModel(
      name: 'Cable Crossover',
      image: 'lib/assets/video_panduan/satu.jpeg',
      description:
          'Cable Crossover adalah alat gym yang digunakan untuk melatih otot dada, terutama bagian tengah dan luar. Gerakan ini juga melibatkan otot bahu dan trisep. Lakukan gerakan dengan rentang gerak penuh, kendalikan beban saat menarik, dan pastikan bahu tidak terangkat berlebihan. Pemula disarankan menggunakan beban ringan dahulu dan fokus pada teknik untuk menghindari cedera.',
    ),
    const PanduanAlatGymModel(
      name: 'Leg Press',
      image: 'lib/assets/video_panduan/dua.jpeg',
      description:
          'Leg Press adalah alat yang dirancang untuk melatih otot quadriceps, hamstring, dan gluteus. Perhatikan posisi kaki di platform untuk menarget area berbeda; posisi tinggi menarget glute & hamstring lebih, posisi rendah menarget quadriceps. Jangan mengunci lutut saat mengunci beban dan kendalikan fase kembali untuk mencegah stres pada sendi.',
    ),
    const PanduanAlatGymModel(
      name: 'Leg Curl',
      image: 'lib/assets/video_panduan/tiga.jpeg',
      description:
          'Leg Curl fokus pada otot hamstring (paha belakang). Gunakan gerakan lambat dan terkontrol, hindari momentum. Pemanasan sebelum melakukannya membantu mengurangi risiko tegang otot. Sesuaikan beban sehingga Anda masih bisa menjaga bentuk sempurna pada setiap repetisi.',
    ),
    const PanduanAlatGymModel(
      name: 'Parallel Bar',
      image: 'lib/assets/video_panduan/empat.jpeg',
      description:
          'Parallel Bar dipakai untuk latihan dips dan variasinya, melatih dada, trisep, dan bahu. Untuk fokus dada biasakan condongkan badan ke depan sedikit saat turun; untuk fokus trisep pertahankan tubuh tegak. Jaga stabilitas bahu dan jangan turun terlalu dalam jika merasa tidak nyaman; progres secara bertahap dengan bantuan atau band jika perlu.',
    ),
  ];
}

