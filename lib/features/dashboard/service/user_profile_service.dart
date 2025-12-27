import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import 'package:chain_fit_app/features/dashboard/model/user_model.dart';

class UserProfileService {
  final ApiService _apiService = ApiService();

  Future<UserProfileData> getProfile() async {
    try {
      // sesuaikan endpoint ini dengan backend kamu
      // contoh: '/api/v1/profile'
      final response = await _apiService.client.get('/api/v1/auth/me');

      // response.data biasanya sudah Map<String, dynamic>
      final parsed = UserProfileResponse.fromJson(response.data);

      if (parsed.code != 200) {
        throw Exception('API error: code=${parsed.code}, status=${parsed.status}');
      }

      return parsed.data;
    } on DioException catch (e) {
      // fallback message biar gak null
      final msg = (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response?.data['message']
          : 'Gagal mengambil profile user';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error parsing profile: $e');
    }
  }
}
