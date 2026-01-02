import 'package:chain_fit_app/core/services/api_service.dart';
import 'package:chain_fit_app/features/video_panduan/model/equipment_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PanduanAlatGymViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  String? _errorMessage;

  List<GymEquipment> _items = [];
  String _query = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get query => _query;
  set query(String value) {
    _query = value;
    notifyListeners();
  }

  List<GymEquipment> get filteredItems {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _items;

    return _items.where((e) {
      final name = e.name.toLowerCase();
      final desc = (e.description ?? '').toLowerCase();
      return name.contains(q) || desc.contains(q);
    }).toList();
  }

  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await _fetchList();
  }

  Future<void> retry() async => init();

  Future<void> _fetchList() async {
    try {
      final res = await _apiService.client.get('/api/v1/equipment/me');

      final List raw = (res.data['data'] as List? ?? []);
      _items = raw.map((e) => GymEquipment.fromJson(e)).toList();
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data?['message']?.toString() ?? 'Gagal memuat data';
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan sistem';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
