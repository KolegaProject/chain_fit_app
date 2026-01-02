import 'dart:io';
import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../model/profile_model.dart';
import '../model/update_profile_model.dart'; // <- tambahin

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
      final msg =
          e.response?.data['message'] ?? e.message ?? 'Gagal mengambil profile';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error parsing profile: $e');
    }
  }

  Future<UpdateProfileData> updateProfile({
    String? username,
    String? name,
    File? imageFile,
  }) async {
    try {
      final formData = FormData();

      if (username != null && username.trim().isNotEmpty) {
        formData.fields.add(MapEntry('username', username.trim()));
      }
      if (name != null && name.trim().isNotEmpty) {
        formData.fields.add(MapEntry('name', name.trim()));
      }
      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.path.split('/').last,
            ),
          ),
        );
      }

      final res = await _apiService.client.put(
        '/api/v1/auth/me/update',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final decoded = res.data as Map<String, dynamic>;
      final parsed = UpdateProfileResponse.fromJson(decoded);

      if (parsed.code != 200) {
        throw Exception(
          'Update gagal: code=${parsed.code}, status=${parsed.status}',
        );
      }
      return parsed.data;
    } on DioException catch (e) {
      final msg =
          e.response?.data['message'] ?? e.message ?? 'Gagal update profile';
      throw Exception(msg);
    }
  }
}
