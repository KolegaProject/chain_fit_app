import 'package:chain_fit_app/core/constants/api_constants.dart';
import 'package:chain_fit_app/core/services/api_service.dart';
import 'package:chain_fit_app/features/payment/models/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PaymentViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isPaying = false;
  String? _errorMessage;
  PaymentData? _paymentData;

  bool get isPaying => _isPaying;
  String? get errorMessage => _errorMessage;
  PaymentData? get paymentData => _paymentData;

  Future<bool> createPayment({
    required int gymId,
    required int packageId,
  }) async {
    if (_isPaying) return false;

    _isPaying = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.client.post(
        ApiConstants.paymentEndpoint,
        data: {
          'gymId': gymId,
          'packageId': packageId,
        },
      );

      final parsed = PaymentResponse.fromJson(response.data);

      if (parsed.code != 200 && parsed.code != 201) {
        throw Exception(parsed.status);
      }

      _paymentData = parsed.data;
      return true;
    } on DioException catch (e) {
      _errorMessage =
          (e.response?.data is Map && e.response?.data['message'] != null)
              ? e.response?.data['message']
              : 'Gagal membuat pembayaran';
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem';
      return false;
    } finally {
      _isPaying = false;
      notifyListeners();
    }
  }
}