// import 'package:flutter/material.dart';
// // Pastikan import ApiService kamu benar
// import 'package:chain_fit_app/core/services/api_service.dart';
// import '../models/membership_models.dart';

// class MembershipViewModel extends ChangeNotifier {
//   // Inject ApiService
//   final ApiService _apiService = ApiService();

//   Membership? _membership;
//   Membership? get membership => _membership;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Future<void> fetchMembershipData() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       // Panggil endpoint sesuai instruksi temanmu
//       final response = await _apiService.client.get(
//         "/api/v1/gym/me/memberships",
//       );

//       if (response.statusCode == 200) {
//         // Asumsi data ada di response.data['data']
//         final data = response.data['data'];
//         _membership = Membership.fromJson(data);
//       }
//     } catch (e) {
//       print("Error: $e");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }


import 'package:chain_fit_app/features/status_membership/models/membership_models.dart';
import 'package:flutter/material.dart';
// Ini import yang sudah diperbaiki sesuai nama project kamu
import 'package:chain_fit_app/core/services/api_service.dart';
// import '../models/membership_models.dart';

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
      // Panggil endpoint backend
      final response = await _apiService.client.get(
        "/api/v1/gym/me/memberships",
      );

      if (response.statusCode == 200) {
        // Cek struktur JSON di Postman, biasanya ada di dalam 'data'
        // Jika response langsung object, hapus ['data']
        final data = response.data['data'];
        _membership = Membership.fromJson(data);
      }
    } catch (e) {
      debugPrint("Error fetching membership: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
