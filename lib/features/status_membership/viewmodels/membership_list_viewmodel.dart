import 'package:flutter/material.dart';
import 'package:chain_fit_app/core/services/api_service.dart'; 
import '../models/membership_models.dart';

class MembershipListViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Membership> _membershipList = [];
  List<Membership> get membershipList => _membershipList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchMembershipList() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.client.get(
        "/api/v1/gym/me/memberships",
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data['data'];
        _membershipList = rawData
            .map((json) => Membership.fromJson(json))
            .toList();
      }
    } catch (e) {
      print("Error fetching list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
