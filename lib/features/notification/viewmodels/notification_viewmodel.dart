import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    // Simulasi fetch data API
    await Future.delayed(const Duration(seconds: 1));
    _notifications = NotificationModel.dummyData;

    _isLoading = false;
    notifyListeners();
  }

  void markAsRead(String id) {
    // Logic untuk update status read
    // Idealnya panggil API, lalu update local state
    final index = _notifications.indexWhere((element) => element.id == id);
    if (index != -1) {
      // _notifications[index] = _notifications[index].copyWith(isRead: true); // Jika ada copyWith
      notifyListeners();
    }
  }
}
