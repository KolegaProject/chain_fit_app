import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../models/list_qr_model.dart';

class ListQrViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool _isRefetching = false;
  String? _errorMessage;

<<<<<<< HEAD
  List<MembershipModel> _memberships = [];

  // Getters (dipakai UI)
=======
  List<MembershipModel> get memberships => _memberships;
  bool get isRefetching => _isRefetching;
>>>>>>> 87dcd510fbe4fa49c82be5453e673e0dd064a1ed
  bool get showFullScreenLoader => _isLoading && _memberships.isEmpty;
  bool get showRefetchingIndicator => _isRefetching;
  bool get showFullScreenError => _errorMessage != null && _memberships.isEmpty;

  String? get errorMessage => _errorMessage;
  List<MembershipModel> get memberships => _memberships;

  Future<void> loadMemberships({bool forceRefresh = false}) async {
    _errorMessage = null;

    if (forceRefresh) {
      _isRefetching = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      // ✅ PAKAI API CONSTANT KAMU YANG LAMA DI SINI
      final res = await _apiService.client.get(
        ApiConstants.activePackageEndpoint,
      );

      final body = res.data;

      // Backend bisa balikin data null (anggap kosong)
      final raw = (body is Map) ? body['data'] : null;

      if (raw == null) {
        _memberships = [];
      } else if (raw is List) {
        _memberships = raw.map((e) => MembershipModel.fromJson(e)).toList();
      } else {
        // kalau bentuknya aneh, tetap jangan crash
        _memberships = [];
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;

      final msg = (body is Map && body['errors'] is Map)
          ? (body['errors']['message']?.toString().toLowerCase())
          : null;

      // ✅ CASE KHUSUS: belum langganan -> bukan error, tapi empty state
      if (status == 404 && msg == 'membership not found') {
        _memberships = [];
        _errorMessage = null;
      } else {
        // Error beneran
        if (body is Map) {
          _errorMessage =
              body['errors']?['message']?.toString() ??
              body['message']?.toString() ??
              'Gagal memuat membership';
        } else {
          _errorMessage = 'Gagal memuat membership';
        }
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      _isRefetching = false;
      notifyListeners();
    }
  }
}
