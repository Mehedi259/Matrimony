import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Profile', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.remove_red_eye, size: 16, color: Colors.white),
              label: const Text('View As', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Completing your profile increases your\nchances of better matches',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 32),
            
            // Profile Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5), width: 4),
                      image: const DecorationImage(
                        image: NetworkImage('https://placehold.co/150/png'), // Mock avatar
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('85% complete', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Kader Molla', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('kader@gmail.com', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // List Items
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  _ProfileListItem(
                    icon: Icons.verified_outlined,
                    title: 'Verify profile',
                    statusText: 'Completed',
                    isCompleted: true,
                  ),
                  _buildDivider(),
                  _ProfileListItem(
                    icon: Icons.person_outline,
                    title: 'Basic Information',
                    subtitle: 'Name, age, height, location, education',
                    statusText: 'Completed',
                    isCompleted: true,
                    onTap: () => context.push('/basic-information-form'),
                  ),
                  _buildDivider(),
                  _ProfileListItem(
                    icon: Icons.location_on_outlined,
                    title: 'Personal Information',
                    subtitle: 'Lifestyle, values, hobbies, about you',
                    statusText: 'Completed',
                    isCompleted: true,
                    onTap: () => context.push('/personal-details-form'),
                  ),
                  _buildDivider(),
                  _ProfileListItem(
                    icon: Icons.favorite_border,
                    title: 'Preferences',
                    subtitle: 'Partner preferences and expectations',
                    statusText: 'Completed',
                    isCompleted: true,
                    onTap: () => context.push('/preferences-form'),
                  ),
                  _buildDivider(),
                  _ProfileListItem(
                    icon: Icons.camera_alt_outlined,
                    title: 'Photos',
                    subtitle: 'Add and manage your photos',
                    statusText: '3/6 Added',
                    isCompleted: false,
                    statusColor: Theme.of(context).primaryColor,
                    onTap: () => context.push('/upload-photo-form'),
                  ),
                  _buildDivider(),
                  _ProfileListItem(
                    icon: Icons.people_outline,
                    title: 'About you & expectations',
                    statusText: 'Completed',
                    isCompleted: true,
                    onTap: () => context.push('/about-expectations-form'),
                  ),
                  _buildDivider(),
                  _ProfileListItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    trailing: const Icon(Icons.chevron_right, color: Colors.black87),
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[200]);
  }
}

class _ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? statusText;
  final bool isCompleted;
  final Color? statusColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileListItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.statusText,
    this.isCompleted = false,
    this.statusColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: subtitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[50], shape: BoxShape.circle),
            child: Icon(icon, color: Colors.black87, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12)),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!
          else if (statusText != null)
            Row(
              children: [
                if (isCompleted) Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.secondary, size: 16),
                if (isCompleted) const SizedBox(width: 4),
                Text(
                  statusText!,
                  style: TextStyle(
                    color: statusColor ?? Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(onTap: onTap, child: content);
    }
    return content;
  }
}
