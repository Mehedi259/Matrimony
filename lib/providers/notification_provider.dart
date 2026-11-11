import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/notification_model.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/notification_repository.dart';

/// Manages shared user notifications and unread admin chat badge state.
class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();
  final ChatRepository _chatRepository = ChatRepository();

  List<NotificationModel> _notifications = [];
  int _unreadAdminMessagesCount = 0;
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _pollingTimer;

  List<NotificationModel> get notifications => _notifications;
  int get unreadAdminMessagesCount => _unreadAdminMessagesCount;
  bool get hasUnreadAdminMessages => _unreadAdminMessagesCount > 0;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Fetches the user's shared notifications list.
  Future<void> fetchNotifications({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      _notifications = await _repository.getNotifications();
      _errorMessage = null;
    } catch (e) {
      if (!silent) {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
    } finally {
      if (!silent) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  /// Marks a single notification as read optimistically and syncs with backend.
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      final current = _notifications[index];
      _notifications[index] = NotificationModel(
        id: current.id,
        title: current.title,
        body: current.body,
        isRead: true,
        type: current.type,
        priority: current.priority,
        data: current.data,
        createdAt: current.createdAt,
      );
      notifyListeners();
    }
    await _repository.markAsRead(notificationId);
  }

  /// Marks all notifications as read on the backend and locally.
  Future<void> markAllAsRead() async {
    final hadUnread = _notifications.any((n) => !n.isRead);
    if (hadUnread) {
      _notifications = _notifications
          .map(
            (n) => NotificationModel(
              id: n.id,
              title: n.title,
              body: n.body,
              isRead: true,
              type: n.type,
              priority: n.priority,
              data: n.data,
              createdAt: n.createdAt,
            ),
          )
          .toList();
      notifyListeners();
    }

    try {
      await _repository.markAllAsRead();
    } catch (_) {
      await fetchNotifications(silent: true);
    }
  }

  /// Refreshes the count of unread messages from admin.
  Future<void> refreshUnreadAdminMessages() async {
    try {
      final room = await _chatRepository.getMyChatRoom();
      if (_unreadAdminMessagesCount != room.unreadCount) {
        _unreadAdminMessagesCount = room.unreadCount;
        notifyListeners();
      }
    } catch (_) {
      // Keep existing badge count on transient errors.
    }
  }

  /// Immediately clears the admin chat unread badge after messages are read.
  void clearUnreadAdminMessages() {
    if (_unreadAdminMessagesCount != 0) {
      _unreadAdminMessagesCount = 0;
      notifyListeners();
    }
  }

  /// Refreshes both notifications and unread admin chat badge silently.
  Future<void> refreshAll() async {
    await Future.wait([
      fetchNotifications(silent: true),
      refreshUnreadAdminMessages(),
    ]);
  }

  /// Starts periodic background polling for notifications and admin messages.
  void startPolling({Duration interval = const Duration(seconds: 20)}) {
    _pollingTimer?.cancel();
    refreshAll();
    _pollingTimer = Timer.periodic(interval, (_) {
      refreshAll();
    });
  }

  /// Stops periodic polling (e.g., on logout or disposal).
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Clears all cached notifications and stops polling (e.g., on logout).
  void clearData() {
    stopPolling();
    _notifications = [];
    _unreadAdminMessagesCount = 0;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
