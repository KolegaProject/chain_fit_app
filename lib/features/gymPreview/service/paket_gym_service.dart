import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../model/paket_gym_model.dart';

class GymPackageService {
  final ApiService _apiService = ApiService();

  Future<List<GymPackage>> getPackagesByGymId(int gymId) async {
    try {
      // sesuaikan endpoint
      // contoh: /api/v1/gym/{gymId}/package
      final response = await _apiService.client.get(
        '/api/v1/gym/$gymId/paket-member',
      );

      final parsed = GymPackageResponse.fromJson(response.data);

      if (parsed.code != 200) {
        throw Exception(
          'API error: code=${parsed.code}, status=${parsed.status}',
        );
      }

      return parsed.data;
    } on DioException catch (e) {
      final msg =
          (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response?.data['message']
          : 'Gagal mengambil paket gym';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error parsing paket: $e');
    }
  }
}
