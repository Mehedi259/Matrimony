import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Notification', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _NotificationCard(
            icon: Icons.person,
            iconBgColor: Colors.white,
            iconColor: Theme.of(context).colorScheme.secondary,
            cardBgColor: const Color(0xFFE8EAF6),
            title: 'Complete your profile',
            subtitle: 'Add profession, photo and short about section. complete profile receive significantly more requests.',
            actionText: 'Complete now',
            onAction: () => context.push('/profile'),
          ),
          const SizedBox(height: 16),
          _NotificationCard(
            icon: Icons.group_add,
            iconBgColor: Colors.white,
            iconColor: Theme.of(context).primaryColor,
            cardBgColor: const Color(0xFFFAF2F3),
            title: 'New Connection Request',
            subtitle: 'S-1201 has sent you a request. View her profile to decide whether you want to approve or decline.',
            actionText: 'View request',
            onAction: () => context.push('/requests'),
            actionColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color cardBgColor;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onAction;
  final Color? actionColor;

  const _NotificationCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.cardBgColor,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAction,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionText,
              style: TextStyle(
                color: actionColor ?? Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
