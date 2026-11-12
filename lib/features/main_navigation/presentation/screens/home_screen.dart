import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/matches_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../widgets/header_action_buttons.dart';
import '../widgets/match_card.dart';
import '../widgets/privacy_banner.dart';
import '../widgets/upgrade_subscription_dialog.dart';
import '../../../../core/utils/snackbar_helper.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final matchesProvider = context.read<MatchesProvider>();
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    await Future.wait([
      authProvider.refreshProfile(),
      profileProvider.loadPhotos(),
      matchesProvider.loadWishlists(),
      matchesProvider.loadConnectionRequestsForRole(authProvider.currentUser?.role),
      matchesProvider.loadMatches(),
      matchesProvider.loadProfileViewers(),
      matchesProvider.fetchConnectionUsage(),
    ]);

    if (!mounted) return;
    await matchesProvider.loadDirectory(page: 1);
  }

  Future<void> _handleSendInterest(String userId) async {
    final matchesProvider = context.read<MatchesProvider>();

    if (matchesProvider.isCurrentUserProfileLocked) {
      Get.showSnackbar(
        const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
          borderRadius: 8,
          duration: Duration(seconds: 3),
          messageText: Text(
            'Your profile is locked in an active Wali discussion.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ),
      );
      return;
    }

    final success = await matchesProvider.sendConnectionRequest(userId);

    if (!mounted) return;

    if (success) {
      SnackBarHelper.showRequestSent(context);
      if (matchesProvider.justExhaustedRequests) {
        showUpgradeSubscriptionDialog(context);
      }
    } else if (matchesProvider.lastSendFailedDueToLimit) {
      showUpgradeSubscriptionDialog(
        context,
        subtitle: matchesProvider.errorMessage,
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText:
              Text(matchesProvider.errorMessage ?? 'Failed to send interest'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final matchesProvider = context.watch<MatchesProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final user = authProvider.currentUser;
    final photos = profileProvider.photos;

    ImageProvider getProfileImage() {
      if (photos.isNotEmpty) {
        final primary = photos.where((p) => p.isPrimary).toList();
        final url = primary.isNotEmpty ? primary.first.imageUrl : photos.first.imageUrl;
        return NetworkImage(url);
      }
      if (user?.profilePicture != null && user!.profilePicture!.isNotEmpty) {
        return NetworkImage(user.profilePicture!);
      }
      return const AssetImage('assets/profileImage.png');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: getProfileImage(),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Welcome ${user?.firstName ?? 'Back'}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
        actions: [
          const SettingsActionButton()
              .animate()
              .fadeIn(duration: 600.ms, delay: 100.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const NotificationBellButton()
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by your preferences',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon:
                      Icon(Icons.search_rounded, color: Colors.grey[400], size: 22),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.tune_rounded, color: Colors.grey[400], size: 20),
                    onPressed: () => context.push('/browse'),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.4),
                        width: 1.5),
                  ),
                ),
                onTap: () => context.push('/browse'),
                readOnly: true,
              ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(
                  begin: -0.2, end: 0),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.visibility_outlined,
                      iconColor: Colors.blue,
                      count: '${matchesProvider.profileViewers.length.toString().padLeft(2, '0')}',
                      label: 'Profile View',
                      onTap: () => context.push('/profile-views'),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.favorite_border,
                      iconColor: Colors.red,
                      count: '${matchesProvider.wishlists.length.toString().padLeft(2, '0')}',
                      label: 'Saved',
                      onTap: () => context.push('/saved'),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 300.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.mail_outline,
                      iconColor: Colors.amber,
                      count: '${(matchesProvider.sentRequests.length + matchesProvider.receivedRequests.length).toString().padLeft(2, '0')}',
                      label: 'Pending',
                      onTap: () => context.go('/requests'),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms)
                        .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Private Matchmaking Button
              GestureDetector(
                onTap: () => context.push('/private-matchmaking'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6E3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: const Center(
                    child: Text('Private Matchmaking',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 500.ms)
                  .shimmer(
                      duration: 2000.ms,
                      delay: 1000.ms,
                      color: Colors.amber[100]),
              const SizedBox(height: 24),

              const Text('Suggested for you',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 16),

              // Loading or Profile Cards
              if (matchesProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (matchesProvider.directoryProfiles.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.people_outline,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No profiles available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...matchesProvider.directoryProfiles.take(5).map((profile) {
                  final index = matchesProvider.directoryProfiles.indexOf(profile);
                  final isSaved = matchesProvider.wishlists.any((w) => (w['user_id'] ?? w['id']) == profile.id);
                  final isConnected = matchesProvider.hasActiveConnectionWith(profile.id);
                  final isRequestSent = !isConnected &&
                      matchesProvider.hasPendingSentRequestTo(profile.id);
                  final canSendRequest = user?.role == 'male';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: MatchCard(
                      username: profile.codename,
                      isVerified: profile.isVerified,
                      age: profile.age != null ? '${profile.age} Years old' : 'N/A',
                      ethnicity: profile.ethnicity ?? 'N/A',
                      country: profile.country ?? 'N/A',
                      imageUrl: null,
                      photos: profile.photos,
                      lockMessage: profile.isProfileLocked && !isConnected
                          ? 'Currently locked in an active Wali discussion'
                          : isConnected
                              ? 'Open profile to view photos safely'
                              : 'Photos will be revealed after mutual interest',
                      isLocked: true,
                      isBlurred: true,
                      isWishlisted: isSaved,
                      isRequestSent: isRequestSent,
                      isConnected: isConnected,
                      onWishlistToggle: () async {
                        if (isSaved) {
                          await matchesProvider.removeFromWishlist(profile.id);
                        } else {
                          await matchesProvider.addToWishlist(profile.id);
                        }
                      },
                      onViewProfile: () {
                        context.push('/matches/directory/${profile.id}').then((_) {
                          if (mounted) _loadData();
                        });
                      },
                      onSendInterest: canSendRequest
                          ? () {
                              if (profile.isProfileLocked) {
                                Get.showSnackbar(
                                  const GetSnackBar(
                                    snackPosition: SnackPosition.TOP,
                                    margin: EdgeInsets.all(16),
                                    borderRadius: 8,
                                    duration: Duration(seconds: 3),
                                    messageText: Text(
                                      'This profile is currently locked in an active Wali discussion.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                );
                                return;
                              }
                              _handleSendInterest(profile.id);
                            }
                          : null,
                    )
                        .animate()
                        .fadeIn(duration: 700.ms, delay: (700 + index * 200).ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                  );
                }).toList(),

              const SizedBox(height: 24),

              const PrivacyBanner()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1100.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String count;
  final String label;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(height: 8),
            Text(count,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
