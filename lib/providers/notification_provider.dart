import 'package:flutter/material.dart';
import '../data/repositories/notification_repository.dart';
import '../data/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _repository.getNotifications();
      // Sort by created_at descending (newest first)
      _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      // Optimistic update
      final notification = _notifications[index];
      _notifications[index] = NotificationModel(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        isRead: true,
        type: notification.type,
        createdAt: notification.createdAt,
      );
      notifyListeners();

      try {
        await _repository.markAsRead(notificationId);
      } catch (e) {
        // Revert on failure
        _notifications[index] = notification;
        notifyListeners();
      }
    }
  }
}
