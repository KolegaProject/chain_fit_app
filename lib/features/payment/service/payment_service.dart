import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../models/payment_model.dart';

class PaymentService {
  final ApiService _apiService = ApiService();

  Future<PaymentData> initiatePayment({
    required int gymId,
    required int packageId,
  }) async {
    try {
      // 1. Fetch user's active/existing memberships to see if they already have one for this gym
      final listResponse = await _apiService.client.get(
        '/api/v1/gym/me/memberships',
      );
      int? existingMembershipId;

      if (listResponse.statusCode == 200) {
        final List<dynamic> rawData = listResponse.data['data'] ?? [];
        for (var item in rawData) {
          final int? itemGymId = int.tryParse(
            item['gym']?['id']?.toString() ?? '',
          );
          if (itemGymId == gymId) {
            existingMembershipId = int.tryParse(item['id']?.toString() ?? '');
            break;
          }
        }
      }

      // 2. Perform the payment request using the appropriate endpoint
      final Response response;
      if (existingMembershipId != null) {
        response = await _apiService.client.put(
          '/api/v1/gym/$gymId/memberships/$existingMembershipId',
          data: {'packageId': packageId},
        );
      } else {
        response = await _apiService.client.post(
          '/api/v1/transaction/create-snap',
          data: {'gymId': gymId, 'packageId': packageId},
        );
      }

      final parsed = PaymentResponse.fromJson(response.data);
      if (parsed.code != 200 && parsed.code != 201) {
        throw Exception(parsed.status);
      }

      return parsed.data;
    } on DioException catch (e) {
      final msg =
          (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response?.data['message']
          : 'Gagal membuat pembayaran';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Gagal memproses pembayaran: $e');
    }
  }

  Future<bool> checkActiveMembership(int gymId) async {
    try {
      final listResponse = await _apiService.client.get(
        '/api/v1/gym/me/memberships',
      );
      if (listResponse.statusCode == 200) {
        final List<dynamic> rawData = listResponse.data['data'] ?? [];
        for (var item in rawData) {
          final int? itemGymId = int.tryParse(
            item['gym']?['id']?.toString() ?? '',
          );
          final String status = item['status']?.toString().toUpperCase() ?? '';
          if (itemGymId == gymId && status == 'AKTIF') {
            return true;
          }
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
