import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../model/search_gym_model.dart';

class GymService {
  final ApiService _apiService = ApiService();

  Future<List<Gym>> searchGyms({String? query}) async {
    try {
      final response = await _apiService.client.get(
        '/api/v1/gym',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'search': query,
        },
      );

      final List list = response.data['data'];
      print('RESPONSE TYPE: ${response.data.runtimeType}');
      print('RESPONSE DATA: ${response.data}');
      return list.map((e) => Gym.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil data gym',
      );
    } catch (e) {
      throw Exception('Error parsing gym: $e');
    }
  }
}
