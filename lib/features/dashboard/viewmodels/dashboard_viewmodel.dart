import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:chain_fit_app/core/services/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../models/user_profile_model.dart';
import '../models/active_package_model.dart';

class DashboardViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  // State
  bool _isLoading = true;
  bool _isRefetching = false;
  String? _errorMessage;

  UserProfileModel? _userProfile;
  List<ActivePackageModel> _activePackages = [];

  // Getters
  bool get isLoading => _isLoading;
  bool get isRefetching => _isRefetching;
  String? get errorMessage => _errorMessage;
  UserProfileModel? get user => _userProfile;
  List<ActivePackageModel> get packages => _activePackages;

  // Logic: User dianggap premium jika ada paket aktif
  bool get isPremium => _activePackages.isNotEmpty;

  Future<void> loadDashboardData({bool forceRefresh = false}) async {
    _errorMessage = null;

    if (!forceRefresh) {
      await _loadFromCache();

      if (_userProfile != null) {
        _isLoading = false;
        notifyListeners();
        _isRefetching = true;
      }
    } else {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final responses = await Future.wait([
        _apiService.client.get(ApiConstants.userProfileEndpoint),
        _apiService.client.get(ApiConstants.activePackageEndpoint),
      ]);

      final profileData = responses[0].data;
      final packageData = responses[1].data;

      _userProfile = UserProfileModel.fromJson(profileData);

      final List rawList = packageData['data'] ?? [];
      _activePackages = rawList
          .map((item) => ActivePackageModel.fromJson(item))
          .toList();

      _cacheService.saveCache(ApiConstants.profileCacheKey, profileData);
      _cacheService.saveCache(ApiConstants.packageCacheKey, packageData);
    } on DioException catch (e) {
      if (_userProfile == null) {
        _errorMessage = e.response?.data['message'] ?? "Gagal memuat data";
      } else {
        debugPrint("Gagal update background: ${e.message}");
      }
    } catch (e) {
      if (_userProfile == null) _errorMessage = "Terjadi kesalahan sistem";
    } finally {
      _isLoading = false;
      _isRefetching = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromCache() async {
    try {
      final profileCache = await _cacheService.getCache(
        ApiConstants.profileCacheKey,
      );
      final packageCache = await _cacheService.getCache(
        ApiConstants.packageCacheKey,
      );

      if (profileCache != null) {
        _userProfile = UserProfileModel.fromJson(profileCache['data']);
      }

      if (packageCache != null) {
        final List rawList = packageCache['data']['data'] ?? [];
        _activePackages = rawList
            .map((item) => ActivePackageModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint("Cache rusak/error: $e");
    }
  }
}