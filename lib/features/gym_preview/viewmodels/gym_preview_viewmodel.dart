import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:chain_fit_app/core/services/api_service.dart';
import 'package:chain_fit_app/core/services/cache_service.dart';
import 'package:chain_fit_app/features/gym_preview/models/gym_package_model.dart';
import 'package:chain_fit_app/features/gym_preview/models/gym_preview_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GymPreviewViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  // ===== STATE =====
  bool _isLoading = true;
  bool _isRefetching = false;
  String? _errorMessage;

  GymPreview? _gym;
  List<GymPackage> _packages = [];

  // ===== GETTERS =====
  bool get isLoading => _isLoading;
  bool get isRefetching => _isRefetching;
  String? get errorMessage => _errorMessage;

  GymPreview? get gym => _gym;
  List<GymPackage> get packages => _packages;

  bool get hasData => _gym != null;
  bool get showSkeleton => isLoading && _gym == null;
  bool get showError => errorMessage != null && _gym == null;

  // ===== INIT =====
  Future<void> init(int gymId, {bool forceRefresh = false}) async {
    _errorMessage = null;

    if (!forceRefresh) {
      await loadFromCache(gymId);

      if (_gym != null) {
        _isLoading = false;
        _isRefetching = true;
        notifyListeners();
      }
    } else {
      _isLoading = true;
      notifyListeners();
    }

    await fetchFromApi(gymId);
  }

  // ===== API FETCH =====
  Future<void> fetchFromApi(int gymId) async {
    try {
      final responses = await Future.wait([
        _apiService.client.get(
          ApiConstants.gymDetailEndpoint(gymId),
        ),
        _apiService.client.get(
          ApiConstants.gymPackageEndpoint(gymId),
        ),
      ]);

      final gymData = responses[0].data;
      final packageData = responses[1].data;

      _gym = GymPreview.fromJson(gymData['data']);

      final List rawPackages = packageData['data'] ?? [];
      _packages = rawPackages
          .map((e) => GymPackage.fromJson(e))
          .toList();

      // Cache
      await _cacheService.saveCache(
        ApiConstants.gymDetailCacheKey(gymId),
        gymData,
      );
      await _cacheService.saveCache(
        ApiConstants.gymPackageCacheKey(gymId),
        packageData,
      );
    } on DioException catch (e) {
      if (_gym == null) {
        _errorMessage =
            e.response?.data['message'] ?? 'Gagal memuat data gym';
      } else {
        debugPrint("Background update failed: ${e.message}");
      }
    } catch (e) {
      if (_gym == null) {
        _errorMessage = 'Terjadi kesalahan sistem';
      }
    } finally {
      _isLoading = false;
      _isRefetching = false;
      notifyListeners();
    }
  }

  // ===== CACHE =====
  Future<void> loadFromCache(int gymId) async {
    try {
      final gymCache = await _cacheService.getCache(
        ApiConstants.gymDetailCacheKey(gymId),
      );
      final packageCache = await _cacheService.getCache(
        ApiConstants.gymPackageCacheKey(gymId),
      );

      if (gymCache != null) {
        _gym = GymPreview.fromJson(gymCache['data']);
      }

      if (packageCache != null) {
        final List rawPackages = packageCache['data']['data'] ?? [];
        _packages = rawPackages
            .map((e) => GymPackage.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Cache error: $e");
    }
  }

  // ===== RETRY =====
  Future<void> retry(int gymId) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    await fetchFromApi(gymId);
  }
}