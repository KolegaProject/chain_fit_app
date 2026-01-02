import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:chain_fit_app/core/services/cache_service.dart';
import 'package:chain_fit_app/core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../models/user_profile_model.dart';
import '../models/active_package_model.dart';

class DashboardViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();
  final LocationService _locationService = LocationService();

  // State
  bool _isLoading = true;
  bool _isRefetching = false;
  String? _errorMessage;

  UserProfileModel? _userProfile;
  List<ActivePackageModel> _activePackages = [];
  Position? _currentPosition;

  // Getters
  bool get isLoading => _isLoading;
  bool get isRefetching => _isRefetching;
  String? get errorMessage => _errorMessage;
  UserProfileModel? get user => _userProfile;
  List<ActivePackageModel> get packages => _activePackages;
  Position? get currentPosition => _currentPosition;

  // Logic: User dianggap premium jika ada paket aktif
  bool get isPremium => _activePackages.isNotEmpty;

  Future<void> loadDashboardData({bool forceRefresh = false}) async {
    _errorMessage = null;

    if (!forceRefresh) {
      await _loadFromCache();

      // Load location in background if using cache
      _getLocation();

      if (_userProfile != null) {
        _isLoading = false;
        notifyListeners();
        _isRefetching = true;
      }
    } else {
      _isLoading = true;
      notifyListeners();

      // Refresh location as well
      await _getLocation();
    }

    // try {
    //   final responses = await Future.wait([
    //     _apiService.client.get(ApiConstants.userProfileEndpoint),
    //     _apiService.client.get(ApiConstants.activePackageEndpoint),
    //   ]);

    //   final profileData = responses[0].data;
    //   final packageData = responses[1].data;

    //   _userProfile = UserProfileModel.fromJson(profileData);

    //   final List rawList = packageData['data'] ?? [];
    //   _activePackages = rawList
    //       .map((item) => ActivePackageModel.fromJson(item))
    //       .toList();

    //   _cacheService.saveCache(ApiConstants.profileCacheKey, profileData);
    //   _cacheService.saveCache(ApiConstants.packageCacheKey, packageData);
    // } on DioException catch (e) {
    //   if (_userProfile == null) {
    //     _errorMessage = e.response?.data['message'] ?? "Gagal memuat data";
    //   } else {
    //     debugPrint("Gagal update background: ${e.message}");
    //   }
    // } catch (e) {
    //   if (_userProfile == null) _errorMessage = "Terjadi kesalahan sistem";
    // } finally {
    //   _isLoading = false;
    //   _isRefetching = false;
    //   notifyListeners();
    // }
    try {
      // 1) Profile WAJIB berhasil
      final profileRes = await _apiService.client.get(
        ApiConstants.userProfileEndpoint,
      );
      final profileData = profileRes.data;
      _userProfile = UserProfileModel.fromJson(profileData);
      _cacheService.saveCache(ApiConstants.profileCacheKey, profileData);

      try {
        final packageRes = await _apiService.client.get(
          ApiConstants.activePackageEndpoint,
        );
        final packageData = packageRes.data;

        final List rawList = (packageData['data'] ?? []) as List;
        _activePackages = rawList
            .map((item) => ActivePackageModel.fromJson(item))
            .toList();

        _cacheService.saveCache(ApiConstants.packageCacheKey, packageData);
      } on DioException catch (e) {
        debugPrint("Package endpoint error: ${e.response?.statusCode}");
        _activePackages = []; // ✅ aman
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? "Gagal memuat data";
    } catch (e) {
      _errorMessage = "Terjadi kesalahan sistem";
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
      final locationCache = await _cacheService.getCache(
        ApiConstants.userLocationCacheKey,
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

      if (locationCache != null && locationCache['data'] != null) {
        _currentPosition = Position(
          longitude: locationCache['data']['longitude'],
          latitude: locationCache['data']['latitude'],
          timestamp: DateTime.parse(locationCache['data']['timestamp']),
          accuracy: locationCache['data']['accuracy'],
          altitude: locationCache['data']['altitude'],
          heading: locationCache['data']['heading'],
          speed: locationCache['data']['speed'],
          speedAccuracy: locationCache['data']['speedAccuracy'],
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      }
    } catch (e) {
      debugPrint("Cache rusak/error: $e");
    }
  }

  Future<void> _getLocation() async {
    try {
      final hasPermission = await _locationService.requestPermission();
      if (hasPermission) {
        final position = await _locationService.getCurrentPosition();
        if (position != null) {
          _currentPosition = position;

          _cacheService.saveCache(ApiConstants.userLocationCacheKey, {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': position.timestamp.toIso8601String(),
            'accuracy': position.accuracy,
            'altitude': position.altitude,
            'heading': position.heading,
            'speed': position.speed,
            'speedAccuracy': position.speedAccuracy,
          });

          if (!_isLoading) notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }
}
