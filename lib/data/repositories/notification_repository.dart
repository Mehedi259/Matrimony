import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(ApiConstants.notifications);
    
    if (response.data is List) {
      return (response.data as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } else if (response.data is Map && response.data['results'] != null) {
      // In case the API returns paginated results
      return (response.data['results'] as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    }
    
    return [];
  }

  Future<void> markAsRead(int notificationId) async {
    // Assuming the endpoint allows marking a specific notification as read.
    // Adjust endpoint based on backend structure if it differs.
    try {
      await _apiClient.post('${ApiConstants.notifications}$notificationId/read/');
    } catch (e) {
      // Ignore if not supported
    }
  }
}
