import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/notification_provider.dart';

/// Reusable settings action button with a red bubble when admin chat has unread messages.
class SettingsActionButton extends StatelessWidget {
  final Color? iconColor;
  final double iconSize;

  const SettingsActionButton({
    super.key,
    this.iconColor,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final unreadAdminCount =
        context.watch<NotificationProvider>().unreadAdminMessagesCount;

    return IconButton(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.settings_outlined,
            color: iconColor ?? Theme.of(context).primaryColor,
            size: iconSize,
          ),
          if (unreadAdminCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
      onPressed: () {
        final notificationProvider = context.read<NotificationProvider>();
        notificationProvider.refreshUnreadAdminMessages();
        context.push('/settings').then((_) {
          notificationProvider.refreshUnreadAdminMessages();
        });
      },
    );
  }
}

/// Reusable notification bell button showing a reactive unread count badge.
class NotificationBellButton extends StatelessWidget {
  final Color? iconColor;
  final Color? badgeColor;
  final double iconSize;

  const NotificationBellButton({
    super.key,
    this.iconColor,
    this.badgeColor,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    return IconButton(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_none,
            color: iconColor ?? Theme.of(context).colorScheme.secondary,
            size: iconSize,
          ),
          if (unreadCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      onPressed: () {
        context.push('/notifications').then((_) {
          if (context.mounted) {
            context.read<NotificationProvider>().fetchNotifications(silent: true);
          }
        });
      },
    );
  }
}
