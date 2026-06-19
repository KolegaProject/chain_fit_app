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

    final urlLower = url.toLowerCase();
    if (urlLower.contains('/finish') ||
        urlLower.contains('pdf-download') ||
        urlLower.contains('pdf-instruction') ||
        urlLower.contains('status_code=200') ||
        urlLower.contains('transaction_status=settlement') ||
        urlLower.contains('transaction_status=capture') ||
        urlLower.contains('success')) {
      return PaymentResult.success;
    }

    if (status == 'cancel' || status == 'deny' || status == 'expire' ||
        urlLower.contains('/unfinish') ||
        urlLower.contains('/error') ||
        urlLower.contains('status_code=202') ||
        urlLower.contains('transaction_status=cancel') ||
        urlLower.contains('transaction_status=deny') ||
        urlLower.contains('transaction_status=expire')) {
      return PaymentResult.failed;
    }

    return null;
  }
}