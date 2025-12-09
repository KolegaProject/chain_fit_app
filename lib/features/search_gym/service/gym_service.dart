import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/search_gym_model.dart';

class GymService {
  static const String baseUrl = 'http://localhost:8000/api/v1';

  Future<List<Gym>> searchGyms(String accessToken, {String? query}) async {
    try {
      final String endpoint = query != null && query.isNotEmpty
          ? '$baseUrl/gym?search=$query'
          : '$baseUrl/gym';

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Sesuaikan dengan struktur response dari API Anda
        List<Gym> gyms = [];
        if (jsonData is Map && jsonData['data'] != null) {
          final data = jsonData['data'];
          if (data is List) {
            gyms = data.map((gym) => Gym.fromJson(gym)).toList();
          }
        }
        return gyms;
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid atau expired');
      } else {
        throw Exception('Gagal mengambil data gym: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
