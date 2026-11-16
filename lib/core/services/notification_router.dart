import 'package:go_router/go_router.dart';

/// Where tapping a notification takes the user. Shared by the in-app
/// notifications list and by system push notifications, so both always open
/// the same screen.
class NotificationRouter {
  NotificationRouter._();

  static const _messageTypes = {'message', 'new_message'};

  /// True when the notification opens the admin chat (the caller may want to
  /// refresh unread admin-message counts afterwards).
  static bool opensAdminChat(String type) =>
      _messageTypes.contains(type.toLowerCase());

  /// Navigates for a notification of [type] with payload [data].
  /// Returns the push future (completes when that screen is popped) or null
  /// when the navigation replaced the stack.
  static Future<Object?>? open(
    GoRouter router,
    String type,
    Map<String, dynamic>? data,
  ) {
    final targetUserId = extractTargetUserId(data);

    switch (type.toLowerCase()) {
      case 'request':
      case 'connection_request_received':
      case 'connection_request_accepted':
      case 'connection_request_declined':
      case 'connection_request_cancelled':
      case 'match':
      case 'match_created':
      case 'photo_request_received':
      case 'photo_request_approved':
      case 'photo_request_declined':
      case 'wali_request_received':
      case 'wali_request_approved':
      case 'wali_request_declined':
      case 'unlock_request_received':
        if (targetUserId != null) {
          return router.push('/profile-view-details/$targetUserId');
        }
        router.go('/requests');
        return null;
      case 'message':
      case 'new_message':
        return router.push('/settings/chat-with-admin');
      case 'profile':
      case 'profile_view':
      case 'profile_viewed':
      case 'new_profile_view':
        if (targetUserId != null) {
          return router.push('/profile-view-details/$targetUserId');
        }
        return router.push('/profile-views');
      case 'profile_approved':
        return router.push('/my-profile-view');
      case 'private_matchmaking_requested':
      case 'private_matchmaking_confirmed':
      case 'pm_approved':
      case 'pm_declined':
      case 'pm_match_update':
      case 'special_match_received':
        return router.push('/private-matches');
      case 'pass_changed':
      case 'password_changed':
      case 'account_suspended':
      case 'account_blocked':
        return router.push('/settings/security');
      case 'welcome':
      case 'new_user_joined':
        // There is no '/' route; Home is the app's start screen.
        router.go('/home');
        return null;
      default:
        if (targetUserId != null) {
          return router.push('/profile-view-details/$targetUserId');
        }
        router.go('/requests');
        return null;
    }
  }

  static String? extractTargetUserId(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return null;
    const candidateKeys = [
      'user_id',
      'other_user_id',
      'sender_id',
      'receiver_id',
      'requester_id',
      'responder_id',
      'viewer_id',
      'profile_id',
    ];
    for (final key in candidateKeys) {
      final raw = data[key]?.toString().trim();
      if (raw != null && raw.isNotEmpty && raw != 'null') {
        return raw;
      }
    }
    return null;
  }
}
