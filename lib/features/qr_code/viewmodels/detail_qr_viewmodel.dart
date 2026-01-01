import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../models/detail_qr_model.dart';

class DetailQrViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  QrTokenResponse? _qrToken;
  bool _isLoading = false;
  String? _errorMessage;

  // ===== GETTERS =====
  QrTokenResponse? get qrToken => _qrToken;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;
  bool get hasData => _qrToken != null;

  // ===== ACTION =====
  Future<void> generateQrToken(int membershipId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.client.post(
        '/api/v1/attendance/$membershipId/qr/me',
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
