import 'package:flutter/material.dart';
import 'dart:ui' as dart_ui;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/screen_protection_service.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/matches_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../../../data/models/matches/match_profile_model.dart';
import '../widgets/header_action_buttons.dart';
import '../widgets/photo_viewer_dialog.dart';
import '../widgets/profile_badges.dart';
import 'package:get/get.dart';

class MatchedProfileViewScreen extends StatefulWidget {
  final String matchId;
  const MatchedProfileViewScreen({super.key, required this.matchId});

  @override
  State<MatchedProfileViewScreen> createState() => _MatchedProfileViewScreenState();
}

class _MatchedProfileViewScreenState extends State<MatchedProfileViewScreen> {
  int _currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeScreenProtection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MatchesProvider>().loadMatches();
      final user = context.read<AuthProvider>().currentUser;
      final role = user?.role.toLowerCase();
      final isFemaleOrWali = role == 'female' ||
          role == 'wali' ||
          user?.gender?.toLowerCase() == 'female';
      if (isFemaleOrWali) {
        final profileProvider = context.read<ProfileProvider>();
        profileProvider.loadBasicInfo();
        if (role == 'wali') {
          profileProvider.loadWaliProfile();
        }
      }
    });
  }

  void _initializeScreenProtection() {
    ScreenProtectionService.setCustomListeners(
      onScreenshot: () {
        if (!mounted) return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        ScreenProtectionService.showScreenshotBlockedNotice();
      },
      onRecord: (isCaptured) {
        if (!mounted) return;
        if (isCaptured) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          ScreenProtectionService.showScreenRecordingBlockedNotice();
        }
      },
    );
  }

  @override
  void dispose() {
    ScreenProtectionService.clearCustomListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MatchesProvider>();
    final MatchModel? match = provider.matches.where(
      (m) => m.matchedUserId == widget.matchId || m.id == widget.matchId || m.matchId == widget.matchId
    ).firstOrNull;

    if (provider.isLoading && match == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (match == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: Text('Match not found')),
      );
    }

    final otherUser = match.otherUser;
    final String name = otherUser['first_name'] ?? otherUser['codename'] ?? 'Unknown';
    final int? age = otherUser['age'];
    final String? height = otherUser['height'];
    final String? profession = otherUser['occupation'];
    final String? bio = otherUser['bio'];
    
    final authUser = context.watch<AuthProvider>().currentUser;
    final isFemaleOrWali = authUser?.role.toLowerCase() == 'female' ||
        authUser?.role.toLowerCase() == 'wali' ||
        authUser?.gender?.toLowerCase() == 'female';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile View', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        actions: [
          const SettingsActionButton(),
          const NotificationBellButton(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'hide', child: Text('Hide Profile')),
              const PopupMenuItem<String>(value: 'block', child: Text('Block Profile')),
              const PopupMenuItem<String>(value: 'report', child: Text('Report Profile')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Top Image Card
            SizedBox(
              height: 350,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  final canOpenPhotos = match.matchedUserPhotos.isNotEmpty &&
                      (isFemaleOrWali || match.photosCurrentlyVisible);
                  if (!canOpenPhotos) return;
                  showProtectedPhotoViewerDialog(
                    context,
                    photos: match.matchedUserPhotos,
                    initialIndex: _currentPhotoIndex,
                    durationSeconds: isFemaleOrWali ? null : 60,
                    onViewerOpened: isFemaleOrWali
                        ? null
                        : () {
                            context
                                .read<MatchesProvider>()
                                .markPhotosViewed(match.id);
                          },
                  );
                },
                child: Stack(
                  children: [
                    PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        _currentPhotoIndex = index;
                      });
                    },
                    itemCount: match.matchedUserPhotos.isNotEmpty ? match.matchedUserPhotos.length : 1,
                    itemBuilder: (context, index) {
                      final Widget imageContainer = Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: const DecorationImage(
                            image: AssetImage('assets/blurredProfile1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            imageContainer,
                            BackdropFilter(
                              filter: ColorFilter.mode(
                                Colors.white.withValues(alpha: 0.1),
                                BlendMode.srcOver,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                            BackdropFilter(
                              filter: dart_ui.ImageFilter.blur(
                                sigmaX: 32,
                                sigmaY: 32,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBE8EA)
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (match.matchedUserPhotos.isNotEmpty)
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.photo_library_outlined, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text('${_currentPhotoIndex + 1}/${match.matchedUserPhotos.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Cancel Connection Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showCancelConnectionDialog(context, match.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE54B5E), // Reddish pink
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Cancel connection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            
            // Photo Viewing & Request Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MatchedPhotoActionSection(
                match: match,
                photos: match.matchedUserPhotos,
                otherCodename: name,
                isFemaleOrWali: isFemaleOrWali,
                onViewerClosed: () async {
                  if (!mounted) return;
                  final matchesProvider = context.read<MatchesProvider>();
                  final authProvider = context.read<AuthProvider>();
                  await Future.wait([
                    matchesProvider.loadMatches(),
                    authProvider.refreshProfile(),
                  ]);
                  if (!mounted) return;
                  final updated = matchesProvider.matches
                      .where((m) => m.id == match.id || m.matchId == match.matchId)
                      .firstOrNull;
                  if (updated == null || !updated.isActiveConnection) {
                    context.pop();
                  } else {
                    setState(() {});
                  }
                },
              ),
            ),

            // About Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF2F3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.person_outline, size: 18),
                      SizedBox(width: 8),
                      Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    bio ?? 'No bio provided.',
                    style: const TextStyle(color: Colors.black87, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF2F3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: VerifiedCodename(
                          codename: match.matchedUserCodename.isNotEmpty
                              ? match.matchedUserCodename
                              : name,
                          isVerified: match.isOtherUserVerified,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                          iconSize: 18,
                        ),
                      ),
                      OnlineStatusBadge(
                        isOnline: match.isOtherUserOnline,
                        offlineLabel: match.otherUserOfflineLastActiveLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.info_outline, size: 18),
                      SizedBox(width: 8),
                      Text('Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _DetailItem(label: 'Name', value: name)),
                      Expanded(child: _DetailItem(label: 'Age', value: age != null ? '$age Years' : 'N/A')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _DetailItem(label: 'Height', value: height ?? 'N/A')),
                      Expanded(child: _DetailItem(label: 'Profession', value: profession ?? 'N/A')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showCancelConnectionDialog(BuildContext context, String matchId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Padding(
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
                          Navigator.of(context).pop();
                          final success = await context.read<MatchesProvider>().cancelMatch(matchId);
                          if (success) {
                            if (context.mounted) context.pop();
                            Get.showSnackbar(const GetSnackBar(
                              messageText: Text('Connection cancelled successfully'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ));
                          } else {
                            if (context.mounted) {
                              Get.showSnackbar(GetSnackBar(
                                messageText: Text(context.read<MatchesProvider>().errorMessage ?? 'Failed to cancel connection'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ));
                            }
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
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
        );
      },
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
