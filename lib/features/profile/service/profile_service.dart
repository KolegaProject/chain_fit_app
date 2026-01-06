import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/services/api_service.dart';
import '../model/profile_model.dart';
import '../model/update_profile_model.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  Future<ProfileData> getProfile() async {
    try {
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
      final data = e.response?.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : (e.message ?? 'Gagal mengambil profile');
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error parsing profile: $e');
    }
  }

  MediaType _guessImageMediaType(String path) {
    final p = path.toLowerCase();
    if (p.endsWith('.png')) return MediaType('image', 'png');
    if (p.endsWith('.jpg') || p.endsWith('.jpeg'))
      return MediaType('image', 'jpeg');
    if (p.endsWith('.webp')) return MediaType('image', 'webp');
    return MediaType('application', 'octet-stream');
  }

  Future<UpdateProfileData> updateProfile({
    String? username,
    String? name,
    File? imageFile,
  }) async {
    try {
      MediaType guessType(String path) {
        final p = path.toLowerCase();
        if (p.endsWith('.png')) return MediaType('image', 'png');
        if (p.endsWith('.jpg') || p.endsWith('.jpeg'))
          return MediaType('image', 'jpeg');
        // fallback biar gak ditolak, tapi sebaiknya file valid jpg/png
        return MediaType('application', 'octet-stream');
      }

      final payload = <String, dynamic>{};

      if (name != null && name.trim().isNotEmpty) {
        payload['name'] = name.trim();
      }
      if (username != null && username.trim().isNotEmpty) {
        payload['username'] = username.trim();
      }

      if (imageFile != null) {
        payload['image'] = await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
          contentType: guessType(imageFile.path), // ✅ INI KUNCINYA
        );
      }

      final formData = FormData.fromMap(payload);

      final res = await _apiService.client.put(
        '/api/v1/auth/me/update',
        data: formData,
        options: Options(headers: const {'Accept': 'application/json'}),
      );

      final decoded = res.data as Map<String, dynamic>;
      final parsed = UpdateProfileResponse.fromJson(decoded);

      if (parsed.code != 200) {
        final err = parsed.errors?.toString();
        throw Exception(
          (err != null && err.isNotEmpty)
              ? err
              : 'Update gagal: code=${parsed.code}, status=${parsed.status}',
        );
      }

      return parsed.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = e.message ?? 'Gagal update profile';
      if (data is Map) {
        if (data['message'] != null) msg = data['message'].toString();
        if (data['errors'] != null) msg = data['errors'].toString();
      }
      throw Exception(msg);
    }
  }
}
