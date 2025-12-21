import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../models/register_model.dart';

class RegisterViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final requestBody = RegisterRequestModel(
        name: name,
        username: username,
        email: email,
        password: password,
      ).toJson();

      final response = await _apiService.client.post(
        ApiConstants.backendUrl + ApiConstants.registerEndpoint,
        data: requestBody,
      );

      final registerResponse = RegisterResponseModel.fromJson(response.data);
      _successMessage = registerResponse.message;
      return true;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        _errorMessage = data['errors']?['message'] ?? 'Register gagal';
      } else {
        _errorMessage = 'Tidak dapat terhubung ke server';
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
  }
}
