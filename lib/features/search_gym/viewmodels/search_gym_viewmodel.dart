import 'package:chain_fit_app/features/search_gym/models/gym_search_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/cache_service.dart';
import 'package:geolocator/geolocator.dart';

class SearchGymViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  bool _isLoading = true;
  bool _isRefetching = false;
  String? _errorMessage;

  List<GymSearchItem> _gyms = [];
  String _query = '';
  Position? _userLocation;

  // ===== GETTERS =====
  bool get isLoading => _isLoading;
  bool get isRefetching => _isRefetching;
  String? get errorMessage => _errorMessage;
  List<GymSearchItem> get gyms => _gyms;
  Position? get userLocation => _userLocation;

  bool get showFullScreenLoader => _isLoading && _gyms.isEmpty;
  bool get showFullScreenError => _errorMessage != null && _gyms.isEmpty;
  bool get showRefetchingIndicator => _isRefetching && _gyms.isNotEmpty;

  // ===== PUBLIC API =====
  Future<void> search({String query = '', bool forceRefresh = false}) async {
    _query = query.trim();
    _errorMessage = null;

    if (!forceRefresh) {
      await _loadFromCache();
      await _loadUserLocation();

      if (_gyms.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        _isRefetching = true;
      }
    } else {
      _isLoading = true;
      notifyListeners();
      await _loadUserLocation();
    }

    try {
      final response = await _apiService.client.get(
        ApiConstants.searchGymEndpoint,
        queryParameters: {if (_query.isNotEmpty) 'search': _query},
      );

      final List list = response.data['data'] ?? [];
      _gyms = list.map((e) => GymSearchItem.fromJson(e)).toList();

      await _cacheService.saveCache(_cacheKey, response.data);
    } on DioException catch (e) {
      if (_gyms.isEmpty) {
        _errorMessage = e.response?.data['message'] ?? 'Gagal memuat data gym';
      }
    } catch (_) {
      if (_gyms.isEmpty) {
        _errorMessage = 'Terjadi kesalahan sistem';
      }
    } finally {
      _isLoading = false;
      _isRefetching = false;
      notifyListeners();
    }
  }

  // ===== CACHE =====
  String get _cacheKey => 'search_gym_${_query.isEmpty ? "all" : _query}';

  Future<void> _loadFromCache() async {
    try {
      final cache = await _cacheService.getCache(_cacheKey);
      if (cache == null) return;

      final List list = cache['data']['data'] ?? [];
      _gyms = list.map((e) => GymSearchItem.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Cache search gym error: $e');
    }
  }

  Future<void> _loadUserLocation() async {
    try {
      final cache = await _cacheService.getCache(
        ApiConstants.userLocationCacheKey,
      );
      if (cache != null && cache['data'] != null) {
        final data = cache['data'];
        _userLocation = Position(
          longitude: data['longitude'],
          latitude: data['latitude'],
          timestamp: DateTime.now(), // approximation, not critical for distance
          accuracy: data['accuracy'],
          altitude: data['altitude'],
          heading: data['heading'],
          speed: data['speed'],
          speedAccuracy: data['speedAccuracy'],
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading location in search: $e");
    }
  }
}
