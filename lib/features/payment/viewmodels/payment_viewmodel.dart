import 'package:chain_fit_app/features/payment/models/payment_model.dart';
import 'package:chain_fit_app/features/payment/service/payment_service.dart';
import 'package:flutter/material.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

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
      _paymentData = await _paymentService.initiatePayment(
        gymId: gymId,
        packageId: packageId,
      );
      return true;
    } catch (e) {
      final displayMessage = e.toString().replaceFirst('Exception: ', '');
      _errorMessage = displayMessage.isNotEmpty ? displayMessage : 'Terjadi kesalahan sistem';
      return false;
    } finally {
      _isPaying = false;
      notifyListeners();
    }
  }

  Future<bool> verifyActiveMembership(int gymId) async {
    return await _paymentService.checkActiveMembership(gymId);
  }
}