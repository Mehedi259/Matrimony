import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<NotificationModel>> getNotifications({int pageSize = 100}) async {
    final response = await _apiClient.get(
      ApiConstants.notifications,
      queryParameters: {'page_size': pageSize},
    );

    if (response.data is List) {
      return (response.data as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } else if (response.data is Map && response.data['results'] != null) {
      return (response.data['results'] as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    }

    return [];
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient.post('${ApiConstants.notifications}$notificationId/mark-read/');
    } catch (e) {
      // Ignore if not supported
    }
  }

  Future<void> markAllAsRead() async {
    await _apiClient.post(ApiConstants.notificationsMarkAllRead);
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get(ApiConstants.notificationsUnreadCount);
      if (response.data is Map && response.data['unread_count'] != null) {
        return (response.data['unread_count'] as num).toInt();
      }
    } catch (_) {
      // Ignore transient errors
    }
    return 0;
  }
}
