import 'package:flutter_test/flutter_test.dart';
import 'package:chain_fit_app/features/payment/domain/payment_redirect_handler.dart';
import 'package:chain_fit_app/features/payment/domain/payment_result.dart';

void main() {
  group('PaymentRedirectHandler Tests', () {
    const handler = PaymentRedirectHandler();

    test('Should return PaymentResult.success for standard status code 200 query param', () {
      const url = 'https://app.sandbox.midtrans.com/callback?status_code=200&order_id=123';
      expect(handler.resolve(url), equals(PaymentResult.success));
    });

    test('Should return PaymentResult.success for settlement or capture status query param', () {
      const url1 = 'https://app.sandbox.midtrans.com/callback?transaction_status=settlement';
      const url2 = 'https://app.sandbox.midtrans.com/callback?transaction_status=capture';
      expect(handler.resolve(url1), equals(PaymentResult.success));
      expect(handler.resolve(url2), equals(PaymentResult.success));
    });

    test('Should return PaymentResult.success when URL contains finish keyword', () {
      const url = 'https://example.com/finish?order_id=123';
      expect(handler.resolve(url), equals(PaymentResult.success));
    });

    test('Should return PaymentResult.success when URL contains Midtrans sandbox success indicators in fragment (SPA)', () {
      const url1 = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/index.html?#/pdf-download';
      const url2 = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/index.html?#/pdf-instruction';
      const url3 = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/index.html?#/success';
      expect(handler.resolve(url1), equals(PaymentResult.success));
      expect(handler.resolve(url2), equals(PaymentResult.success));
      expect(handler.resolve(url3), equals(PaymentResult.success));
    });

    test('Should return PaymentResult.failed when URL contains cancel, deny, or expire status query param', () {
      const url1 = 'https://app.sandbox.midtrans.com/callback?transaction_status=cancel';
      const url2 = 'https://app.sandbox.midtrans.com/callback?transaction_status=deny';
      const url3 = 'https://app.sandbox.midtrans.com/callback?transaction_status=expire';
      expect(handler.resolve(url1), equals(PaymentResult.failed));
      expect(handler.resolve(url2), equals(PaymentResult.failed));
      expect(handler.resolve(url3), equals(PaymentResult.failed));
    });

    test('Should return PaymentResult.failed when URL contains error or unfinish keywords', () {
      const url1 = 'https://example.com/unfinish?order_id=123';
      const url2 = 'https://example.com/error?order_id=123';
      expect(handler.resolve(url1), equals(PaymentResult.failed));
      expect(handler.resolve(url2), equals(PaymentResult.failed));
    });

    test('Should return null for pending state status code 201', () {
      const url = 'https://app.sandbox.midtrans.com/callback?status_code=201&transaction_status=pending';
      expect(handler.resolve(url), isNull);
    });

    test('Should return null for typical midtrans payment selection page URL', () {
      const url = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/index.html?#/gopay-instruction';
      expect(handler.resolve(url), isNull);
    });
  });
}
