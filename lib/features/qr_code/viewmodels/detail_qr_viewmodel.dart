import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import '../../../core/enums/view_state.dart';
import '../../../core/services/api_service.dart';
import '../models/detail_qr_model.dart';

class DetailQrViewModel extends ChangeNotifier {
  final ApiService _apiService;

  DetailQrViewModel({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  QrTokenResponse? _qrToken;
  bool _isLoading = false;
  String? _errorMessage;

  // ===== GETTERS =====
  QrTokenResponse? get qrToken => _qrToken;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;
  bool get hasData => _qrToken != null;

  ViewState get state {
    if (_isLoading) {
      return ViewState.loading;
    } else if (_errorMessage != null) {
      return ViewState.error;
    } else if (_qrToken == null) {
      return ViewState.empty;
    } else {
      return ViewState.success;
    }
  }

  // ===== ACTION =====
  Future<void> generateQrToken(int membershipId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.client.post(
        ApiConstants.qrEndpoint(membershipId),
      );
      _qrToken = QrTokenResponse.fromJson(response.data['data']['token']);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _qrToken = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
