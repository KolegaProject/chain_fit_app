import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:chain_fit_app/core/enums/view_state.dart';
import 'package:chain_fit_app/core/services/api_service.dart';
import 'package:chain_fit_app/core/services/cache_service.dart';
import 'package:chain_fit_app/features/qr_code/models/list_qr_model.dart';
import 'package:flutter/material.dart';

class ListQrViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final CacheService _cacheService;

  ListQrViewModel({
    ApiService? apiService,
    CacheService? cacheService,
  })  : _apiService = apiService ?? ApiService(),
        _cacheService = cacheService ?? CacheService();

  List<MembershipModel> _memberships = [];
  bool _isLoading = false;
  bool _isRefetching = false;
  String? _errorMessage;

  List<MembershipModel> get memberships => _memberships;
  bool get isLoading => _isLoading;
  bool get isRefetching => _isRefetching;
  String? get errorMessage => _errorMessage;
  bool get showFullScreenLoader => _isLoading && _memberships.isEmpty;
  bool get showFullScreenError => _errorMessage != null;

  ViewState get state {
    if (showFullScreenLoader) {
      return ViewState.loading;
    } else if (showFullScreenError) {
      return ViewState.error;
    } else if (_memberships.isEmpty) {
      return ViewState.empty;
    } else {
      return ViewState.success;
    }
  }

  Future<void> loadMemberships({bool forceRefresh = false}) async {
    if (_isLoading || _isRefetching) return;

    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    if (!forceRefresh) {
      await _loadFromDashboardCache();

      if (_memberships.isNotEmpty) {
        _isLoading = false;
        _isRefetching = true;
        notifyListeners();
      }
    }

    try {
      final response = await _apiService.client.get(
        ApiConstants.activePackageEndpoint,
      );

      final List rawList = response.data['data'] ?? [];
      _memberships = rawList.map((e) => MembershipModel.fromJson(e)).toList();

      await _cacheService.saveCache(
        ApiConstants.packageCacheKey,
        response.data,
      );
    } catch (e) {
      if (_apiService.isNotFoundError(e)) {
        _memberships = [];
        await _cacheService.removeCache(ApiConstants.packageCacheKey);
      } else {
        if (_memberships.isEmpty) {
          _errorMessage = "Gagal memuat data membership. Periksa koneksi Anda.";
        }
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
