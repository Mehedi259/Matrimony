import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/notification_provider.dart';
import '../../../../data/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              if (provider.notifications.isEmpty || provider.unreadCount == 0) {
                return const SizedBox();
              }
              return TextButton(
                onPressed: () => provider.markAllAsRead(),
                child: const Text('Mark all read'),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final notifications = provider.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'re all caught up!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchNotifications(),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(context, notifications[index], provider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, NotificationModel notification, NotificationProvider provider) {
    final bool isRead = notification.isRead;
    final String type = notification.type ?? '';
    
    IconData icon;
    Color iconColor;
    
    switch (type.toLowerCase()) {
      case 'request':
      case 'connection_request_received':
        icon = Icons.person_add;
        iconColor = Colors.blue;
        break;
      case 'match':
      case 'match_created':
      case 'connection_request_accepted':
        icon = Icons.favorite;
        iconColor = Colors.red;
        break;
      case 'connection_request_declined':
      case 'connection_request_cancelled':
        icon = Icons.cancel_outlined;
        iconColor = Colors.redAccent;
        break;
      case 'message':
      case 'new_message':
        icon = Icons.message;
        iconColor = Colors.green;
        break;
      case 'profile':
      case 'profile_approved':
        icon = Icons.visibility;
        iconColor = Colors.orange;
        break;
      case 'photo_request_received':
      case 'photo_request_approved':
      case 'photo_request_declined':
      case 'wali_request_received':
      case 'wali_request_approved':
      case 'wali_request_declined':
      case 'unlock_request_received':
        icon = Icons.camera_alt_outlined;
        iconColor = Colors.purple;
        break;
      case 'private_matchmaking_requested':
      case 'private_matchmaking_confirmed':
      case 'pm_approved':
      case 'pm_declined':
      case 'pm_match_update':
      case 'special_match_received':
        icon = Icons.star_outline;
        iconColor = Colors.amber.shade800;
        break;
      case 'account_suspended':
      case 'account_blocked':
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.red;
        break;
      case 'pass_changed':
        icon = Icons.lock_outline;
        iconColor = Colors.blueGrey;
        break;
      case 'welcome':
        icon = Icons.celebration;
        iconColor = Colors.teal;
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Container(
      color: isRead ? Colors.white : Colors.blue.withOpacity(0.05),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.body,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(DateTime.tryParse(notification.createdAt) ?? DateTime.now()),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          if (!isRead) {
            provider.markAsRead(notification.id);
          }
          
          // Navigate based on notification type
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
              context.push('/requests');
              break;
            case 'message':
            case 'new_message':
              context.push('/settings/chat-with-admin').then((_) {
                if (context.mounted) {
                  context.read<NotificationProvider>().refreshUnreadAdminMessages();
                }
              });
              break;
            case 'profile':
              context.push('/profile-views');
              break;
            case 'profile_approved':
              context.push('/my-profile-view');
              break;
            case 'private_matchmaking_requested':
            case 'private_matchmaking_confirmed':
            case 'pm_approved':
            case 'pm_declined':
            case 'pm_match_update':
            case 'special_match_received':
              context.push('/private-matches');
              break;
          }
        },
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
