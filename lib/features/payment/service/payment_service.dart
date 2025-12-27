import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../model/payment_model.dart';

class PaymentService {
  final ApiService _apiService = ApiService();

  Future<PaymentData> createPayment({
    required int packageId,
    required int gymId,
  }) async {
    try {
      // sesuaikan endpoint kamu ya (contoh)
      final response = await _apiService.client.post(
        '/api/v1/transaction/create-snap',
        data: {"packageId": packageId, "gymId": gymId},
      );

      final parsed = PaymentResponse.fromJson(response.data);

      if (parsed.code != 201 && parsed.code != 200) {
        throw Exception(
          'API error: code=${parsed.code}, status=${parsed.status}',
        );
      }

      return parsed.data;
    } on DioException catch (e) {
      final msg =
          (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response?.data['message']
          : 'Gagal membuat pembayaran';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error parsing payment: $e');
    }
  }
}
