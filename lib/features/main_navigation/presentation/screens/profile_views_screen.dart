import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/matches_provider.dart';
import '../widgets/header_action_buttons.dart';
import '../widgets/profile_badges.dart';

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
        actions: const [
          SettingsActionButton(),
          NotificationBellButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<MatchesProvider>(
        builder: (context, matchesProvider, _) {
          if (matchesProvider.isLoadingProfileViewers &&
              matchesProvider.profileViewers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (matchesProvider.profileViewersError != null &&
              matchesProvider.profileViewersError!.isNotEmpty) {
            final errText = matchesProvider.profileViewersError!;
            final requiresUpgrade = errText.toLowerCase().contains('upgrade') ||
                errText.toLowerCase().contains('monthly') ||
                errText.toLowerCase().contains('annual');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      requiresUpgrade
                          ? Icons.workspace_premium_outlined
                          : Icons.visibility_off_outlined,
                      size: 56,
                      color: requiresUpgrade
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (requiresUpgrade) {
                          context.push('/subscription-plans');
                        } else {
                          matchesProvider.loadProfileViewers();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        requiresUpgrade ? 'Upgrade Plan' : 'Retry',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final viewers = matchesProvider.profileViewers;

          if (viewers.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => matchesProvider.loadProfileViewers(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: const [
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No one has viewed your profile yet.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => matchesProvider.loadProfileViewers(),
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: viewers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final viewer = viewers[index];
                final profile = (viewer is Map && viewer['profile'] is Map)
                    ? Map<String, dynamic>.from(viewer['profile'] as Map)
                    : <String, dynamic>{};

                final userId =
                    (profile['id'] ?? profile['user_id'] ?? '').toString();
                final codename = (profile['codename'] ??
                        profile['username'] ??
                        'Member')
                    .toString();
                final age = profile['age'];
                final country = profile['country']?.toString();
                final subtitleParts = <String>[
                  if (age != null) '$age yrs',
                  if (country != null && country.isNotEmpty) country,
                ];
                final subtitle = subtitleParts.isNotEmpty
                    ? '${subtitleParts.join(' • ')} viewed your profile.'
                    : '$codename viewed your profile.';

                return _ProfileViewCard(
                  username: codename,
                  isVerified: profile['is_verified'] == true,
                  subtitle: subtitle,
                  onViewProfile: () {
                    if (userId.isNotEmpty) {
                      context.push('/profile-view-details/$userId');
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ProfileViewCard extends StatelessWidget {
  final String username;
  final bool isVerified;
  final String subtitle;
  final VoidCallback onViewProfile;

  const _ProfileViewCard({
    required this.username,
    this.isVerified = false,
    required this.subtitle,
    required this.onViewProfile,
  });

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
                    VerifiedCodename(
                      codename: username,
                      isVerified: isVerified,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      iconSize: 16,
                    ),
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
