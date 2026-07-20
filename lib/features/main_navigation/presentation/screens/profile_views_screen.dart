import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/matches_provider.dart';

class ProfileViewsScreen extends StatefulWidget {
  const ProfileViewsScreen({super.key});

  @override
  State<ProfileViewsScreen> createState() => _ProfileViewsScreenState();
}

class _ProfileViewsScreenState extends State<ProfileViewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchesProvider>().loadProfileViewers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile Views', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).primaryColor),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.secondary, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                  ),
                ),
              ],
            ),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<MatchesProvider>(
        builder: (context, matchesProvider, _) {
          if (matchesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (matchesProvider.errorMessage != null && matchesProvider.errorMessage!.isNotEmpty) {
            return Center(
              child: Text(
                matchesProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          final viewers = matchesProvider.profileViewers;

          if (viewers.isEmpty) {
            return const Center(
              child: Text(
                'No one has viewed your profile yet.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: viewers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final viewer = viewers[index];
              final profile = viewer['profile'] ?? {};
              
              final userId = profile['user_id'] ?? profile['id']?.toString() ?? profile['username'] ?? '';
              final username = profile['username'] ?? 'Unknown User';
              final firstName = profile['first_name'] ?? '';
              final lastName = profile['last_name'] ?? '';
              final fullName = firstName.isNotEmpty || lastName.isNotEmpty 
                  ? '$firstName $lastName'.trim() 
                  : username;

              return _ProfileViewCard(
                username: username,
                subtitle: '$fullName has shown interest in your profile.',
                onViewProfile: () {
                  if (userId.isNotEmpty) {
                    context.push('/profile-view-details/$userId');
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfileViewCard extends StatelessWidget {
  final String username;
  final String subtitle;
  final VoidCallback onViewProfile;

  const _ProfileViewCard({required this.username, required this.subtitle, required this.onViewProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF2F3), // light pink background
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Theme.of(context).primaryColor.withOpacity(0.5)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onViewProfile,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'View profile',
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
