import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../models/user_profile_model.dart';
import '../models/active_package_model.dart';

class DashboardViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State
  bool _isLoading = true;
  String? _errorMessage;
  
  UserProfileModel? _userProfile;
  List<ActivePackageModel> _activePackages = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserProfileModel? get user => _userProfile;
  List<ActivePackageModel> get packages => _activePackages;
  
  // Logic: User dianggap premium jika ada paket aktif
  bool get isPremium => _activePackages.isNotEmpty;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Kita panggil 2 API secara paralel agar lebih cepat
      final responses = await Future.wait([
        _apiService.client.get(ApiConstants.userProfileEndpoint),
        _apiService.client.get(ApiConstants.activePackageEndpoint)
      ]);

      // Parse Profile
      _userProfile = UserProfileModel.fromJson(responses[0].data);

      final packageResponse = responses[1].data;
      
      // Ambil array 'data'
      final List rawList = packageResponse['data'] ?? [];
      
      // Map setiap item ke Model
      _activePackages = rawList
          .map((item) => ActivePackageModel.fromJson(item))
          .toList();

    } on DioException catch (e) {
      // Jika profile gagal load, itu fatal.
      _errorMessage = e.response?.data['message'] ?? "Gagal memuat data dashboard";
    } catch (e, stackTrace) {
      debugPrint("❌ SYSTEM ERROR: $e");
      debugPrint("Stacktrace: $stackTrace");
      _errorMessage = "Terjadi kesalahan sistem";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}