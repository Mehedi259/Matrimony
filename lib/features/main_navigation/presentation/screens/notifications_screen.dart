import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // TODO: Integrate with NotificationRepository when backend endpoint is ready
  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'request',
      'title': 'New Connection Request',
      'message': 'mm005 sent you a connection request',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
    },
    {
      'type': 'match',
      'title': 'New Match!',
      'message': 'You have a new match with mf003',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
    },
    {
      'type': 'message',
      'title': 'New Message',
      'message': 'Admin replied to your message',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': true,
    },
    {
      'type': 'profile',
      'title': 'Profile View',
      'message': 'mm012 viewed your profile',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
    },
  ];

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
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification['isRead'] = true;
                }
              });
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
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
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final bool isRead = notification['isRead'];
    final String type = notification['type'];
    
    IconData icon;
    Color iconColor;
    
    switch (type) {
      case 'request':
        icon = Icons.person_add;
        iconColor = Colors.blue;
        break;
      case 'match':
        icon = Icons.favorite;
        iconColor = Colors.red;
        break;
      case 'message':
        icon = Icons.message;
        iconColor = Colors.green;
        break;
      case 'profile':
        icon = Icons.visibility;
        iconColor = Colors.orange;
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
          notification['title'],
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
              notification['message'],
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification['time']),
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
          setState(() {
            notification['isRead'] = true;
          });
          
          // Navigate based on notification type
          switch (type) {
            case 'request':
              context.push('/requests');
              break;
            case 'match':
              context.push('/requests');
              break;
            case 'message':
              context.push('/settings/chat-with-admin');
              break;
            case 'profile':
              context.push('/profile-views');
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
