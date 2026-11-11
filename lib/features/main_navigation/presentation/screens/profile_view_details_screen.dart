import 'package:flutter/material.dart';
import 'dart:ui' as dart_ui;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/matches_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../data/models/matches/match_profile_model.dart';
import '../../../../core/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../../../core/constants/choice_mappings.dart';
import '../widgets/photo_viewer_dialog.dart';
import '../widgets/upgrade_subscription_dialog.dart';

class ProfileViewDetailsScreen extends StatefulWidget {
  final String userId;
  
  const ProfileViewDetailsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileViewDetailsScreen> createState() => _ProfileViewDetailsScreenState();
}

class _ProfileViewDetailsScreenState extends State<ProfileViewDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  MatchProfileModel? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _tabLabels = ['Basic Info', 'About Me', 'Preferences'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
    // Use addPostFrameCallback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final matchesProvider = context.read<MatchesProvider>();
    final role = context.read<AuthProvider>().currentUser?.role;
    final profileFuture = matchesProvider.getProfileDetails(widget.userId);
    await Future.wait<void>([
      profileFuture,
      matchesProvider.loadMatches(),
      matchesProvider.loadConnectionRequestsForRole(role),
    ]);

    if (!mounted) return;
    final success = await profileFuture;
    if (success && matchesProvider.selectedProfile != null) {
      setState(() {
        _profile = matchesProvider.selectedProfile;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = matchesProvider.selectedProfileError ??
            matchesProvider.errorMessage ??
            'Failed to load profile';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSendInterest() async {
    if (_profile == null) return;

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

    final success = await matchesProvider.sendConnectionRequest(_profile!.id);

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
          messageText: Text(matchesProvider.errorMessage ?? 'Failed to send interest'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleRespondToReceivedRequest(
    String requestId, {
    required bool accept,
  }) async {
    final matchesProvider = context.read<MatchesProvider>();
    final success = await matchesProvider.respondToRequest(
      requestId: requestId,
      accept: accept,
    );

    if (!mounted) return;

    if (success) {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(
            accept
                ? 'Connection accepted! You are now matched.'
                : 'Request declined.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: accept ? Colors.green : Colors.orange,
        ),
      );
      if (!accept) {
        context.pop();
      } else {
        setState(() {});
      }
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(
            matchesProvider.errorMessage ?? 'Failed to respond to request',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCancelConnectionDialog(BuildContext context, String matchId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFE54B5E), size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Cancel Connection?',
                  style: TextStyle(color: Color(0xFFE54B5E), fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Are you sure you want to cancel this connection? You will no longer be matched with this profile.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          final success = await context.read<MatchesProvider>().cancelMatch(matchId);
                          if (!mounted) return;
                          if (success) {
                            Get.showSnackbar(const GetSnackBar(
                              messageText: Text('Connection cancelled successfully'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ));
                            setState(() {});
                          } else {
                            Get.showSnackbar(GetSnackBar(
                              messageText: Text(context.read<MatchesProvider>().errorMessage ?? 'Failed to cancel connection'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDF8B8F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Keep', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleCancelRequest(String requestId) async {
    final matchesProvider = context.read<MatchesProvider>();
    final success = await matchesProvider.cancelRequest(requestId);
    if (!mounted) return;
    if (success) {
      Get.showSnackbar(const GetSnackBar(
        messageText: Text('Connection request cancelled'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ));
      setState(() {});
    } else {
      Get.showSnackbar(GetSnackBar(
        messageText: Text(matchesProvider.errorMessage ?? 'Failed to cancel request'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _profile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Profile not found',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadProfileData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: CustomScrollView(
        slivers: [
          // ── Hero SliverAppBar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              ),
            ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.7, 0.7)),
            actions: [
              GestureDetector(
                onTap: () => context.push('/settings'),
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms).scale(begin: const Offset(0.7, 0.7)),
              PopupMenuButton<String>(
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_horiz, color: Colors.white, size: 20),
                ),
                onSelected: (value) {
                  // Handle menu actions
                  Get.showSnackbar(
                    GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('$value selected')),
                  );
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'Hide Profile', child: Text('Hide Profile')),
                  const PopupMenuItem<String>(value: 'Block Profile', child: Text('Block Profile')),
                  const PopupMenuItem<String>(value: 'Report Profile', child: Text('Report Profile')),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Builder(
                builder: (context) {
                  final matchesProvider = context.watch<MatchesProvider>();
                  final matchingMatch =
                      matchesProvider.activeMatchForUser(_profile!.id);
                  final isMatch = matchingMatch != null;
                  final authUser = context.watch<AuthProvider>().currentUser;
                  final isFemaleOrWali =
                      authUser?.role.toLowerCase() == 'female' ||
                          authUser?.role.toLowerCase() == 'wali' ||
                          authUser?.gender?.toLowerCase() == 'female';
                  final availablePhotos = isMatch &&
                          matchingMatch.matchedUserPhotos.isNotEmpty
                      ? matchingMatch.matchedUserPhotos
                      : _profile!.photos;

                  return GestureDetector(
                    onTap: () {
                      if (!isMatch || availablePhotos.isEmpty) return;
                      if (!isFemaleOrWali &&
                          !matchingMatch.photosCurrentlyVisible) {
                        return;
                      }
                      showProtectedPhotoViewerDialog(
                        context,
                        photos: availablePhotos,
                        durationSeconds: isFemaleOrWali ? null : 60,
                        onViewerOpened: isFemaleOrWali
                            ? null
                            : () {
                                matchesProvider
                                    .markPhotosViewed(matchingMatch.id);
                              },
                      );
                    },
                    child: _HeroImageSection(
                      primaryColor: primaryColor,
                      photoBlurred: true,
                      lockMessage: isMatch
                          ? 'Photos remain hidden for privacy. Use View Photos below.'
                          : 'Photos revealed after mutual interest',
                      codename: _profile!.codename,
                      photos: _profile!.photos,
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Profile Header Info ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _profile!.codename,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Builder(
                              builder: (context) {
                                final ageText = _profile!.age != null ? '${_profile!.age} years' : '';
                                final ethnicityText = (_profile!.ethnicity != null && _profile!.ethnicity!.isNotEmpty)
                                    ? ChoiceMappings.keysStringToDisplay(_profile!.ethnicity!, ChoiceMappings.ethnicityKeyToDisplay)
                                    : '';
                                final cityText = _profile!.city ?? '';
                                final countryText = _profile!.country ?? '';
                                final locationText = [cityText, countryText]
                                    .where((s) => s.isNotEmpty && s.toLowerCase() != 'string')
                                    .join(', ');
                                final subtitle = [ageText, ethnicityText, locationText].where((s) => s.isNotEmpty).join(' • ');
                                return Text(
                                  subtitle,
                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (_profile!.isOnline)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Online',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 16),

                  // Quick info chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_profile!.occupation != null && _profile!.occupation!.isNotEmpty)
                        _InfoChip(
                          icon: Icons.work_outline,
                          label: _formatOccupation(_profile!.occupation!),
                          color: Colors.blue,
                        ),
                      if (_profile!.height != null)
                        _InfoChip(
                          icon: Icons.height,
                          label: _profile!.height!,
                          color: Colors.orange,
                        ),
                      if (_profile!.maritalStatus != null && _profile!.maritalStatus!.isNotEmpty)
                        _InfoChip(
                          icon: Icons.star_outline,
                          label: ChoiceMappings.keyToDisplay(
                            _profile!.maritalStatus!,
                            ChoiceMappings.maritalStatusKeyToDisplay,
                          ),
                          color: Colors.purple,
                        ),
                      if (_profile!.sect != null && _profile!.sect!.isNotEmpty)
                        _InfoChip(
                          icon: Icons.menu_book_outlined,
                          label: ChoiceMappings.keyToDisplay(
                            _profile!.sect!,
                            ChoiceMappings.sectKeyToDisplay,
                          ),
                          color: Colors.teal,
                        ),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 350.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 20),

                  // Action Buttons (Send Interest, Cancel Connection, Cancel Request)
                  Builder(
                    builder: (context) {
                      final matchesProvider = context.watch<MatchesProvider>();
                      final authUser = context.watch<AuthProvider>().currentUser;
                      final hasSent = matchesProvider.hasPendingSentRequestTo(_profile!.id);
                      final hasReceived = matchesProvider.hasPendingReceivedRequestFrom(_profile!.id);
                      final matchingMatch = matchesProvider.activeMatchForUser(_profile!.id);
                      final isMatch = matchingMatch != null;
                      final canSendRequest = authUser?.role == 'male';
                      final isFemaleOrWali =
                          authUser?.role.toLowerCase() == 'female' ||
                              authUser?.role.toLowerCase() == 'wali' ||
                              authUser?.gender?.toLowerCase() == 'female';

                      final matchingSent = matchesProvider.sentRequests.where((req) => req.receiverId == _profile!.id).firstOrNull;

                      if (isMatch) {
                        final availablePhotos = matchingMatch.matchedUserPhotos.isNotEmpty
                            ? matchingMatch.matchedUserPhotos
                            : _profile!.photos;

                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                                  SizedBox(width: 8),
                                  Text('You are connected', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            MatchedPhotoActionSection(
                              match: matchingMatch,
                              photos: availablePhotos,
                              otherCodename: _profile!.codename,
                              isFemaleOrWali: isFemaleOrWali,
                              accentColor: secondaryColor,
                              onViewerClosed: () {
                                if (mounted) {
                                  context.read<MatchesProvider>().loadMatches();
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: () => _showCancelConnectionDialog(context, matchingMatch.id),
                                icon: const Icon(Icons.cancel_outlined, size: 18, color: Colors.white),
                                label: const Text('Cancel Connection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE54B5E),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 600.ms, delay: 450.ms).slideY(begin: 0.2, end: 0);
                      }

                      if (hasSent && matchingSent != null) {
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time_rounded, color: Colors.orange, size: 20),
                                  SizedBox(width: 8),
                                  Text('Connection request pending', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: () => _handleCancelRequest(matchingSent.id),
                                icon: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
                                label: const Text('Cancel Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE54B5E),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 600.ms, delay: 450.ms).slideY(begin: 0.2, end: 0);
                      }

                      final matchingReceived = matchesProvider.receivedRequests
                          .where((req) => req.otherUser['id'] == _profile!.id)
                          .firstOrNull;

                      if (hasReceived && matchingReceived != null) {
                        return Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _handleRespondToReceivedRequest(
                                    matchingReceived.id,
                                    accept: false,
                                  ),
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: Color(0xFFE54B5E),
                                  ),
                                  label: const Text(
                                    'Decline',
                                    style: TextStyle(
                                      color: Color(0xFFE54B5E),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFE54B5E),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _handleRespondToReceivedRequest(
                                    matchingReceived.id,
                                    accept: true,
                                  ),
                                  icon: const Icon(
                                    Icons.check_circle_outline,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Accept Request',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 600.ms, delay: 450.ms).slideY(begin: 0.2, end: 0);
                      }

                      final bool isLockedOut =
                          matchesProvider.isCurrentUserProfileLocked;
                      final String buttonText = isLockedOut
                          ? 'Profile Locked (In Discussion)'
                          : 'Send Interest';
                      final bool isEnabled = canSendRequest && !isLockedOut;

                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: isEnabled ? _handleSendInterest : null,
                          icon: Icon(
                            isLockedOut
                                ? Icons.lock_outline_rounded
                                : Icons.favorite_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(
                            buttonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            disabledBackgroundColor: primaryColor.withValues(alpha: 0.5),
                            disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 450.ms).slideY(begin: 0.2, end: 0);
                    }
                  ),
                  const SizedBox(height: 24),

                  // Privacy notice
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: secondaryColor.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: secondaryColor, size: 18),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Full name, photos & contact details are shared only at the appropriate stage.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF475569),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 550.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Custom Tab Bar ─────────────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              tabController: _tabController,
              labels: _tabLabels,
              selectedIndex: _selectedTab,
              primaryColor: primaryColor,
              onTap: (i) {
                setState(() => _selectedTab = i);
                _tabController.animateTo(i);
              },
            ),
          ),

          // ── Tab Content ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                key: ValueKey(_selectedTab),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                child: _selectedTab == 0
                    ? _buildBasicInfoTab(primaryColor)
                    : _selectedTab == 1
                        ? _buildAboutMeTab(primaryColor)
                        : _buildPreferencesTab(primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Basic Info ────────────────────────────────────────────────────────
  String _formatOccupation(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'N/A';
    if (!trimmed.contains('_') && trimmed != trimmed.toLowerCase()) {
      return trimmed;
    }
    return trimmed
        .replaceAll('_', ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  Widget _buildBasicInfoTab(Color primaryColor) {
    final fields = [
      ['Codename', _profile!.codename],
      ['Age', _profile!.age?.toString() ?? 'N/A'],
      ['City', _profile!.city ?? 'N/A'],
      ['Country', _profile!.country ?? 'N/A'],
      ['Sect', _profile!.sect != null ? ChoiceMappings.keyToDisplay(_profile!.sect!, ChoiceMappings.sectKeyToDisplay) : 'N/A'],
      ['Marital Status', _profile!.maritalStatus != null ? ChoiceMappings.keyToDisplay(_profile!.maritalStatus!, ChoiceMappings.maritalStatusKeyToDisplay) : 'N/A'],
      ['Ethnicity', _profile!.ethnicity != null ? ChoiceMappings.keysStringToDisplay(_profile!.ethnicity!, ChoiceMappings.ethnicityKeyToDisplay) : 'N/A'],
      ['Height', _profile!.height ?? 'N/A'],
      ['Occupation', _profile!.occupation != null ? _formatOccupation(_profile!.occupation!) : 'N/A'],
      ['Education', _profile!.education != null ? ChoiceMappings.keyToDisplay(_profile!.education!, ChoiceMappings.educationKeyToDisplay) : 'N/A'],
      if (_profile!.nationality != null && _profile!.nationality!.isNotEmpty)
        ['Nationality', ChoiceMappings.keysStringToDisplay(_profile!.nationality!, ChoiceMappings.nationalityKeyToDisplay)],
      if (_profile!.pray5x != null && _profile!.pray5x!.isNotEmpty)
        ['Prayer 5x a day?', ChoiceMappings.keyToDisplay(_profile!.pray5x!, ChoiceMappings.prayerKeyToDisplay)],
      if (_profile!.openToRelocate != null && _profile!.openToRelocate!.isNotEmpty)
        ['Open to relocating?', ChoiceMappings.keyToDisplay(_profile!.openToRelocate!, ChoiceMappings.relocationKeyToDisplay)],
      if (_profile!.dress.isNotEmpty)
        ['Dress', ChoiceMappings.keysToDisplays(_profile!.dress, ChoiceMappings.dressKeyToDisplay).join(', ')],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(fields.length, (i) {
        return _InfoRow(
          label: fields[i][0],
          value: fields[i][1],
          primaryColor: primaryColor,
        ).animate()
            .fadeIn(duration: 400.ms, delay: Duration(milliseconds: i * 40))
            .slideX(begin: 0.1, end: 0);
      }),
    );
  }

  // ── About Me ──────────────────────────────────────────────────────────
  Widget _buildAboutMeTab(Color primaryColor) {
    final fields = <MapEntry<String, String>>[];

    void addField(String label, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        fields.add(MapEntry(label, value.trim()));
      }
    }

    final aboutYourself = _profile!.aboutYourself?.trim().isNotEmpty == true
        ? _profile!.aboutYourself
        : _profile!.bio;
    if (_profile!.about != null &&
        _profile!.about!.trim().isNotEmpty &&
        _profile!.about!.trim() != aboutYourself?.trim()) {
      addField('About', _profile!.about);
    }
    addField('About Yourself', aboutYourself);
    addField('Idea of Marriage', _profile!.envisionMarriage);
    addField('Relationship with Islam', _profile!.relationshipWithIslam);
    addField('Role as a Spouse', _profile!.roleAsSpouse);
    addField('Envision Your Spouse', _profile!.envisionSpouse);
    addField(
      "Spouse's Religious Status Preference",
      _profile!.spouseReligiousStatusPref,
    );
    addField('Relocation Details', _profile!.openToRelocateDetails);
    addField('Health Concerns', _profile!.healthConcerns);
    addField('Other Preferences', _profile!.otherPreferences);
    addField(
      'Languages',
      (_profile!.languages != null && _profile!.languages!.trim().isNotEmpty)
          ? ChoiceMappings.keysStringToDisplay(
              _profile!.languages!,
              ChoiceMappings.languageKeyToDisplay,
            )
          : null,
    );

    if (fields.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            label: 'About',
            value: 'No information provided',
            primaryColor: primaryColor,
            multiLine: true,
          ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < fields.length; i++)
          _InfoRow(
            label: fields[i].key,
            value: fields[i].value,
            primaryColor: primaryColor,
            multiLine: fields[i].key != 'Languages',
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: (50 * i).ms)
              .slideX(begin: 0.1, end: 0),
      ],
    );
  }

  // ── Preferences ───────────────────────────────────────────────────────
  Widget _buildPreferencesTab(Color primaryColor) {
    final fields = <MapEntry<String, String>>[];

    if (_profile!.prefAgeMin != null && _profile!.prefAgeMax != null) {
      fields.add(MapEntry(
        'Preferred Age Range',
        '${_profile!.prefAgeMin} - ${_profile!.prefAgeMax} years',
      ));
    } else if (_profile!.prefAgeMin != null) {
      fields.add(MapEntry('Minimum Age', '${_profile!.prefAgeMin} years'));
    } else if (_profile!.prefAgeMax != null) {
      fields.add(MapEntry('Maximum Age', '${_profile!.prefAgeMax} years'));
    }

    if (_profile!.prefMaritalStatus.isNotEmpty) {
      fields.add(MapEntry(
        'Preferred Marital Status',
        ChoiceMappings.keysToDisplays(
          _profile!.prefMaritalStatus,
          ChoiceMappings.maritalStatusKeyToDisplay,
        ).join(', '),
      ));
    }

    if (_profile!.prefEthnicity.isNotEmpty) {
      fields.add(MapEntry(
        'Preferred Ethnicity',
        ChoiceMappings.keysToDisplays(
          _profile!.prefEthnicity,
          ChoiceMappings.ethnicityKeyToDisplay,
        ).join(', '),
      ));
    }

    if (_profile!.prefCountryOfResidence.isNotEmpty) {
      fields.add(MapEntry(
        'Preferred Country of Residence',
        _profile!.prefCountryOfResidence.join(', '),
      ));
    }

    if (_profile!.preferredDress.isNotEmpty) {
      fields.add(MapEntry(
        'Preferred Dress',
        ChoiceMappings.keysToDisplays(
          _profile!.preferredDress,
          ChoiceMappings.dressKeyToDisplay,
        ).join(', '),
      ));
    }

    if (fields.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'No preferences specified',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ).animate().fadeIn(duration: 400.ms),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < fields.length; i++)
          _InfoRow(
            label: fields[i].key,
            value: fields[i].value,
            primaryColor: primaryColor,
            multiLine: true,
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: (50 * i).ms)
              .slideX(begin: 0.1, end: 0),
      ],
    );
  }
}

// ── Hero Image Section ─────────────────────────────────────────────────────────
class _HeroImageSection extends StatelessWidget {
  final Color primaryColor;
  final bool photoBlurred;
  final String lockMessage;
  final String codename;
  final List<dynamic> photos;

  const _HeroImageSection({
    required this.primaryColor,
    required this.photoBlurred,
    this.lockMessage = 'Photos revealed after mutual interest',
    required this.codename,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider = (!photoBlurred && photos.isNotEmpty)
        ? NetworkImage(photos.first['image'])
        : const AssetImage('assets/blurredProfile1.png');

    return Stack(
      fit: StackFit.expand,
      children: [
        // Profile image
        Image(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
        
        if (photoBlurred)
          ClipRect(
            child: BackdropFilter(
              filter: dart_ui.ImageFilter.blur(sigmaX: 32, sigmaY: 32),
              child: Container(
                color: const Color(0xFFFBE8EA).withValues(alpha: 0.35),
              ),
            ),
          ),
        
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.5),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        
        // Lock message if photo is blurred
        if (photoBlurred)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      photos.isNotEmpty
                          ? '${photos.length} photo${photos.length == 1 ? '' : 's'} • $lockMessage'
                          : lockMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Sticky Tab Bar Delegate ────────────────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<String> labels;
  final int selectedIndex;
  final Color primaryColor;
  final ValueChanged<int> onTap;

  _TabBarDelegate({
    required this.tabController,
    required this.labels,
    required this.selectedIndex,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF6F7FB),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFEBEDF2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: List.generate(labels.length, (i) {
            final isSelected = i == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [BoxShadow(color: primaryColor.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 2))]
                        : [],
                  ),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? primaryColor : Colors.grey[500],
                    ),
                    child: Text(labels[i]),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}

// ── Info Row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color primaryColor;
  final bool multiLine;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.primaryColor,
    this.multiLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: multiLine ? null : 1,
                overflow: multiLine ? null : TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info Chip ─────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
