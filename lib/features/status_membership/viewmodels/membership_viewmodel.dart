import 'package:chain_fit_app/features/status_membership/models/membership_models.dart';
import 'package:flutter/material.dart';
import 'package:chain_fit_app/core/services/api_service.dart';

class MembershipViewModel extends ChangeNotifier {
  // Inject ApiService
  final ApiService _apiService = ApiService();

  Membership? _membership;
  Membership? get membership => _membership;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchMembershipData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.client.get(
        "/api/v1/gym/me/memberships",
      );

      if (response.statusCode == 200) {
        debugPrint("Membership API Response: ${response.data}");
        final data = response.data['data'];

        if (data != null && data is List && data.isNotEmpty) {
          // Ambil data pertama dari list
          _membership = Membership.fromJson(data[0]);
        } else if (data is Map<String, dynamic>) {
          _membership = Membership.fromJson(data);
        } else {
          debugPrint("Membership data format invalid or empty");
        }
      } else {
        debugPrint(
          "Membership API Error: ${response.statusCode} - ${response.statusMessage}",
        );
      }
    } catch (e) {
      debugPrint("Error fetching membership: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
