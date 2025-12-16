import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../models/login_model.dart';

class LoginViewModel extends ChangeNotifier {
  // Dependency
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // State
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fungsi Login
  // Return Future<bool> agar View tahu kapan harus navigasi pindah halaman
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final requestBody = LoginRequestModel(
        username: username,
        password: password,
      ).toJson();

      // Panggil API menggunakan Dio client dari ApiService
      final response = await _apiService.client.post(
        ApiConstants.loginEndpoint,
        data: requestBody,
      );

      final loginResponse = LoginResponseModel.fromJson(response.data);

      await _storageService.saveTokens(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
      );

      return true; // Login Sukses
    } on DioException catch (e) {
      // Handle Error dari Dio
      if (e.response != null) {
        _errorMessage = e.response?.data['message'] ?? 'Login gagal';
      } else {
        _errorMessage = 'Terjadi kesalahan koneksi';
      }
      return false; // Login Gagal
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false; // Login Gagal
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
