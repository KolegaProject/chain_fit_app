import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'storage_service.dart';
import '../../features/list_qr/models/list_qr_model.dart';

class ApiService {
  late Dio _dio;
  final StorageService _storageService = StorageService();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Menambahkan Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Otomatis ambil token dari storage
          final token = await _storageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('➡️ ${options.method} ${options.uri}');
          print('➡️ query: ${options.queryParameters}');
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle error global, misal 401 Unauthorized -> Logout otomatis
          print("API Error: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  // Getter agar bisa diakses public
  Dio get client => _dio;

  Future<List<MembershipModel>> getMyMemberships() async {
  try {
    // Ubah path di sini menjadi /api/v1/gym/me/memberships
    final response = await _dio.get('/api/v1/gym/me/memberships'); 

    if (response.statusCode == 200) {
      List rawData = response.data['data']; 
      return rawData.map((json) => MembershipModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data membership');
    }
  } on DioException catch (e) {
    // Memberikan pesan error yang lebih spesifik jika token expired (401)
    if (e.response?.statusCode == 401) {
      throw Exception('Sesi telah berakhir, silakan login kembali');
    }
    throw Exception(e.message ?? 'Terjadi kesalahan jaringan');
  }
}
}
