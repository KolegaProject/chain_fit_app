import 'package:chain_fit_app/features/payment/domain/payment_result.dart';

class PaymentRedirectHandler {
  const PaymentRedirectHandler();

  PaymentResult? resolve(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    final status =
        uri.queryParameters['transaction_status']?.toLowerCase();
    final code = uri.queryParameters['status_code'];

    if (status == 'settlement' || status == 'capture') {
      return PaymentResult.success;
    }

    if (code == '200') {
      return PaymentResult.success;
    }

    if (url.toLowerCase().contains('/finish')) {
      return PaymentResult.success;
    }

    if (status == 'cancel' || status == 'deny' || status == 'expire') {
      return PaymentResult.failed;
    }

    return null;
  }
}