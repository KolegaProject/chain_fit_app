import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../model/profile_model.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  Future<ProfileData> getProfile() async {
    try {
      // Samakan endpoint kamu (contoh sebelumnya: /profile atau /api/v1/profile)
      final res = await _apiService.client.get('/api/v1/auth/me');

      final decoded = res.data as Map<String, dynamic>;
      final parsed = ProfileResponse.fromJson(decoded);

      if (parsed.code != 200) {
        throw Exception(
          'API error: code=${parsed.code}, status=${parsed.status}',
        );
      }

      return parsed.data;
    } on DioException catch (e) {
      final msg =
          e.response?.data['message'] ?? e.message ?? 'Gagal mengambil profile';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error parsing profile: $e');
    }
  }
}
