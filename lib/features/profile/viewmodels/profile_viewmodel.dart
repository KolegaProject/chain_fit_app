import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/services/api_service.dart';
import '../service/logout_service.dart';
import '../model/profile_model.dart';
import '../model/update_profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  // Dependencies
  final ApiService _apiService = ApiService();
  final AuthLogout _logoutService = AuthLogout();

  // State
  ProfileData? _data;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isLoggingOut = false;
  String? _errorMessage;

  // Getters
  ProfileData? get data => _data;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isLoggingOut => _isLoggingOut;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _apiService.client.get('/api/v1/auth/me');
      final decoded = res.data as Map<String, dynamic>;
      final parsed = ProfileResponse.fromJson(decoded);

      if (parsed.code != 200) {
        throw Exception('API error: code=${parsed.code}, status=${parsed.status}');
      }

      _data = parsed.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : (e.message ?? 'Gagal mengambil profile');
      _errorMessage = msg;
    } catch (e) {
      _errorMessage = 'Error parsing profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Return bool biar View bisa show snackbar / tutup modal
  Future<bool> updateProfile({
    String? username,
    String? name,
    File? imageFile,
  }) async {
    if (_isSaving) return false;

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
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
        );
      }

      final res = await _apiService.client.put(
        '/api/v1/auth/me/update',
        data: FormData.fromMap(payload),
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

      // Setelah update sukses, refresh profile biar UI update
      await fetchProfile();
      return true;
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = e.message ?? 'Gagal update profile';
      if (data is Map) {
        if (data['message'] != null) msg = data['message'].toString();
        if (data['errors'] != null) msg = data['errors'].toString();
      }
      _errorMessage = msg;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    if (_isLoggingOut) return false;

    _isLoggingOut = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _logoutService.logout();
      return true;
    } catch (e) {
      _errorMessage = "Gagal logout: $e";
      return false;
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }
}
