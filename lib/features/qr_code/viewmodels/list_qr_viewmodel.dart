import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:chain_fit_app/core/services/api_service.dart';
import 'package:chain_fit_app/core/services/cache_service.dart';
import 'package:chain_fit_app/features/qr_code/models/list_qr_model.dart';
import 'package:flutter/material.dart';

class ListQrViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  List<MembershipModel> _memberships = [];
  bool _isLoading = true;
  bool _isRefetching = false;
  String? _errorMessage;

  List<MembershipModel> get memberships => _memberships;
  bool get showFullScreenLoader => _isLoading && _memberships.isEmpty;
  bool get showFullScreenError => _errorMessage != null && _memberships.isEmpty;

  Future<void> loadMemberships({bool forceRefresh = false}) async {
    _errorMessage = null;

    if (!forceRefresh) {
      await _loadFromDashboardCache();

      if (_memberships.isNotEmpty) {
        _isLoading = false;
        _isRefetching = true;
        notifyListeners();
      }
    } else {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final response = await _apiService.client.get(
        ApiConstants.activePackageEndpoint,
      );

      final List rawList = response.data['data'] ?? [];
      _memberships = rawList.map((e) => MembershipModel.fromJson(e)).toList();
    } catch (e) {
      if (_memberships.isEmpty) {
        _errorMessage = "Gagal memuat data membership";
      }
    } finally {
      _isLoading = false;
      _isRefetching = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromDashboardCache() async {
    try {
      final cache = await _cacheService.getCache(ApiConstants.packageCacheKey);

      if (cache != null) {
        final List rawList = cache['data']['data'] ?? [];
        _memberships = rawList.map((e) => MembershipModel.fromJson(e)).toList();
      }
    } catch (_) {}
  }
}
