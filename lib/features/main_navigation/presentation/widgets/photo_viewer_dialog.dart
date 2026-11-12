import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import '../../../../core/constants/choice_mappings.dart';
import '../../../../data/models/matches/match_profile_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/matches_provider.dart';
import '../../../../providers/profile_provider.dart';

/// Opens a screenshot-protected fullscreen photo viewer dialog with pinch-to-zoom.
///
/// When [durationSeconds] is provided, displays a live countdown and closes the
/// dialog automatically when the timer reaches zero.
Future<void> showProtectedPhotoViewerDialog(
  BuildContext context, {
  required List<dynamic> photos,
  int initialIndex = 0,
  int? durationSeconds,
  VoidCallback? onViewerOpened,
}) async {
  if (photos.isEmpty) {
    Get.showSnackbar(
      const GetSnackBar(
        messageText: Text('No photos available'),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  try {
    final isRecording = await ScreenProtector.isRecording();
    if (isRecording) {
      Get.showSnackbar(
        const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
          borderRadius: 8,
          duration: Duration(seconds: 4),
          messageText: Text(
            'Screen recording detected. Please stop recording to view photos.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await ScreenProtector.preventScreenshotOn();
  } catch (e) {
    debugPrint('ScreenProtector check error: $e');
  }

  if (!context.mounted) return;

  onViewerOpened?.call();

  final safeInitial =
      initialIndex.clamp(0, photos.length - 1);
  final PageController pageController = PageController(initialPage: safeInitial);
  int currentIndex = safeInitial;
  int secondsLeft = durationSeconds ?? 0;
  Timer? timer;

  await showDialog(
    context: context,
    barrierDismissible: durationSeconds == null,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (innerContext, setStateDialog) {
          if (durationSeconds != null && (timer == null || !timer!.isActive)) {
            timer = Timer.periodic(const Duration(seconds: 1), (t) {
              if (!dialogContext.mounted) {
                t.cancel();
                return;
              }
              if (secondsLeft > 0) {
                setStateDialog(() {
                  secondsLeft--;
                });
              } else {
                t.cancel();
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              }
            });
          }

          return Dialog.fullscreen(
            backgroundColor: Colors.black,
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: photos.length,
                  onPageChanged: (index) {
                    setStateDialog(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final item = photos[index];
                    final imageUrl =
                        item is Map ? item['image']?.toString() : null;
                    if (imageUrl == null || imageUrl.isEmpty) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 48,
                        ),
                      );
                    }
                    return InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: SizedBox.expand(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 46,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${currentIndex + 1} / ${photos.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                if (durationSeconds != null)
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Time left: ${secondsLeft}s',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      timer?.cancel();
                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  ).then((_) {
    timer?.cancel();
    pageController.dispose();
  });
}

/// Shared photo status, request, approval, timed viewer, and Wali details lifecycle section.
class MatchedPhotoActionSection extends StatelessWidget {
  final MatchModel match;
  final List<dynamic> photos;
  final String otherCodename;
  final bool isFemaleOrWali;
  final Color? accentColor;
  final VoidCallback? onViewerClosed;

  const MatchedPhotoActionSection({
    super.key,
    required this.match,
    required this.photos,
    required this.otherCodename,
    required this.isFemaleOrWali,
    this.accentColor,
    this.onViewerClosed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = accentColor ?? Theme.of(context).colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPhotoSection(context, buttonColor),
        const SizedBox(height: 12),
        _buildWaliSection(context, buttonColor),
      ],
    );
  }

  Widget _buildPhotoSection(BuildContext context, Color buttonColor) {
    if (isFemaleOrWali) {
      return Column(
        children: [
          if (match.photoRequestStatus == 'requested' &&
              match.photoRequestedByOtherUser)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.photo_camera_front, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Photo Request',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    match.secondPhotoRequestStatus == 'pending'
                        ? '$otherCodename has requested a second and final 60-second window to view your photos.'
                        : '$otherCodename has requested to view your photos for 60 seconds.',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await context
                                .read<MatchesProvider>()
                                .respondToPhotoRequest(
                                  matchId: match.id,
                                  accept: false,
                                );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await context
                                .read<MatchesProvider>()
                                .respondToPhotoRequest(
                                  matchId: match.id,
                                  accept: true,
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Approve',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (photos.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.photo_library_outlined, color: buttonColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Photos are hidden for privacy. Tap below to view full screen.',
                          style: TextStyle(color: Colors.black87, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await showProtectedPhotoViewerDialog(
                              context,
                              photos: photos,
                            );
                            onViewerClosed?.call();
                          },
                          icon: const Icon(
                            Icons.fullscreen_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            'View Photos',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    String infoText;
    if (match.photoViewCount == 0) {
      if (match.photosCurrentlyVisible) {
        infoText = 'Photos unlocked! You have 60 seconds to view them.';
      } else if (match.photoRequestStatus == 'requested') {
        infoText = 'Photo request sent. Waiting for approval.';
      } else if (match.photoRequestStatus == 'rejected') {
        infoText = 'Your photo request was declined.';
      } else {
        infoText = 'Request to view photos for 60 seconds.';
      }
    } else if (match.photoViewCount == 1) {
      if (match.photosCurrentlyVisible) {
        infoText = 'Photos unlocked! This is your final 60-second view.';
      } else if (match.secondPhotoRequestStatus == 'pending') {
        infoText = 'Second photo request sent. Waiting for approval.';
      } else if (match.secondPhotoRequestStatus == 'rejected') {
        infoText = 'Your second photo request was declined.';
      } else {
        infoText = 'Your initial viewing time has expired.';
      }
    } else {
      infoText = 'You have used both of your photo viewing opportunities.';
    }

    String buttonText = '';
    VoidCallback? onPressed;
    if (match.photosCurrentlyVisible) {
      buttonText = match.photoViewCount == 0
          ? 'View Photos (60s)'
          : 'View Photos (Final 60s)';
      onPressed = () async {
        final provider = context.read<MatchesProvider>();
        await showProtectedPhotoViewerDialog(
          context,
          photos: photos,
          durationSeconds: 60,
          onViewerOpened: () {
            provider.markPhotosViewed(match.id);
          },
        );
        onViewerClosed?.call();
      };
    } else if (match.photoViewCount == 0 && match.photoRequestStatus == 'none') {
      buttonText = 'Request to view photos';
      onPressed = () async {
        final success =
            await context.read<MatchesProvider>().requestPhotoView(match.id);
        if (success && context.mounted) {
          Get.showSnackbar(
            const GetSnackBar(
              messageText: Text('Photo request sent successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      };
    } else if (match.photoViewCount == 1 &&
        match.secondPhotoRequestStatus == 'none') {
      buttonText = 'Request a second view';
      onPressed = () async {
        final success =
            await context.read<MatchesProvider>().requestPhotoView(match.id);
        if (success && context.mounted) {
          Get.showSnackbar(
            const GetSnackBar(
              messageText: Text('Second photo request sent successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      };
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: buttonColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  infoText,
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
                if (buttonText.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  T? _tryWatch<T>(BuildContext context) {
    try {
      return context.watch<T>();
    } on ProviderNotFoundException {
      return null;
    }
  }

  Widget _buildWaliSection(BuildContext context, Color buttonColor) {
    final matchesProvider = _tryWatch<MatchesProvider>(context);
    final profileProvider = _tryWatch<ProfileProvider>(context);
    final authRole =
        _tryWatch<AuthProvider>(context)?.currentUser?.role.toLowerCase() ?? '';

    final bool isOtherLockedElsewhere =
        !match.isDiscussionLocked && match.otherUser['is_profile_locked'] == true;
    final bool isSelfLockedElsewhere = !match.isDiscussionLocked &&
        (matchesProvider?.isCurrentUserProfileLocked ?? false);
    final bool isBlockedByDiscussionLock =
        isSelfLockedElsewhere || isOtherLockedElsewhere;

    if (match.isWaliApproved) {
      String? resolvedName = match.waliName;
      String? resolvedNumber = match.waliNumber;
      String? resolvedRelationRaw = match.waliRelation;

      if (isFemaleOrWali) {
        if (authRole == 'wali') {
          final wp = profileProvider?.waliProfile;
          resolvedName = (resolvedName != null && resolvedName.trim().isNotEmpty)
              ? resolvedName
              : wp?.waliName;
          resolvedNumber =
              (resolvedNumber != null && resolvedNumber.trim().isNotEmpty)
                  ? resolvedNumber
                  : wp?.phone;
          resolvedRelationRaw =
              (resolvedRelationRaw != null && resolvedRelationRaw.trim().isNotEmpty)
                  ? resolvedRelationRaw
                  : wp?.relationToSister;
        } else {
          final info = profileProvider?.basicInfo;
          resolvedName = (resolvedName != null && resolvedName.trim().isNotEmpty)
              ? resolvedName
              : info?.waliName;
          resolvedNumber =
              (resolvedNumber != null && resolvedNumber.trim().isNotEmpty)
                  ? resolvedNumber
                  : info?.waliNumber;
          resolvedRelationRaw =
              (resolvedRelationRaw != null && resolvedRelationRaw.trim().isNotEmpty)
                  ? resolvedRelationRaw
                  : info?.waliRelation;
        }
      }

      final displayName = (resolvedName != null && resolvedName.trim().isNotEmpty)
          ? resolvedName.trim()
          : 'Not provided';
      final displayNumber =
          (resolvedNumber != null && resolvedNumber.trim().isNotEmpty)
              ? resolvedNumber.trim()
              : 'Not provided';
      final relation =
          (resolvedRelationRaw != null && resolvedRelationRaw.trim().isNotEmpty)
              ? ChoiceMappings.keyToDisplay(
                  resolvedRelationRaw.trim(),
                  ChoiceMappings.waliRelationKeyToDisplay,
                )
              : null;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF8EB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_rounded, size: 16, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Both profiles are locked for Wali discussion',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Icon(Icons.family_restroom_outlined, size: 18),
                SizedBox(width: 8),
                Text(
                  'Wali Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _WaliField(
                    label: 'Wali Name',
                    value: displayName,
                  ),
                ),
                Expanded(
                  child: _WaliField(
                    label: 'Wali Number',
                    value: displayNumber,
                  ),
                ),
              ],
            ),
            if (relation != null && relation.isNotEmpty) ...[
              const SizedBox(height: 10),
              _WaliField(label: 'Relation', value: relation),
            ],
            if (match.status.toLowerCase() == 'in_discussion' ||
                match.status.toLowerCase() == 'wali_accepted') ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmUnlock(context),
                  icon: const Icon(Icons.lock_open_rounded, size: 16),
                  label: const Text('Unlock / End Discussion'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(color: Colors.deepPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (isBlockedByDiscussionLock) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.lock_rounded, color: Colors.deepPurple, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isSelfLockedElsewhere
                    ? 'Your profile is currently locked in another Wali discussion. End that discussion before sending or accepting Wali details here.'
                    : '$otherCodename is currently locked in another Wali discussion.',
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (isFemaleOrWali) {
      final isRequested = match.waliRequestStatus.toLowerCase() == 'requested';
      if (isRequested) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Wali Details Request',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$otherCodename has requested your Wali details. Approving will present Wali details and lock both profiles.',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await context
                            .read<MatchesProvider>()
                            .respondToWaliRequest(
                              matchId: match.id,
                              accept: false,
                            );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final provider = context.read<MatchesProvider>();
                        final success = await provider.respondToWaliRequest(
                          matchId: match.id,
                          accept: true,
                        );
                        if (!context.mounted) return;
                        if (success) {
                          Get.showSnackbar(
                            const GetSnackBar(
                              messageText: Text(
                                'Wali details sent and both profiles locked.',
                              ),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          Get.showSnackbar(
                            GetSnackBar(
                              messageText: Text(
                                provider.errorMessage ?? 'Unable to send Wali details',
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Send Wali Details',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Next Step: Wali Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Once $otherCodename requests your Wali details after viewing photos, you can approve and send them here.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.send_rounded, size: 16),
                label: const Text('Send Wali Details'),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Male side
    final waliStatus = match.waliRequestStatus.toLowerCase();
    if (waliStatus == 'requested') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.amber[200]!),
        ),
        child: const Row(
          children: [
            Icon(Icons.hourglass_top_rounded, color: Colors.amber),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Wali details requested. Waiting for sister/wali approval.',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    final bool canRequestWali =
        match.status.toLowerCase() == 'accepted' && !match.photosCurrentlyVisible;
    if (!canRequestWali) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: buttonColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ready for the next step?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            waliStatus == 'declined'
                ? 'Your previous Wali request was declined. You may request again.'
                : 'Request Wali details to move forward. Once approved, both profiles will lock.',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final provider = context.read<MatchesProvider>();
                final success = await provider.requestWaliDetails(match.id);
                if (!context.mounted) return;
                if (success) {
                  Get.showSnackbar(
                    const GetSnackBar(
                      messageText: Text('Wali details request sent!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  Get.showSnackbar(
                    GetSnackBar(
                      messageText: Text(
                        provider.errorMessage ?? 'Failed to request Wali details',
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.verified_user_outlined,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Request Wali Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmUnlock(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Unlock & End Discussion?'),
        content: const Text(
          'Warning: This will immediately cancel and drop this connection, '
          'permanently remove the Wali details, unlock both profiles, '
          'and notify the other person that you have ended the Wali stage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Keep Connection'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final provider = context.read<MatchesProvider>();
              final success = await provider.unlockMatch(match.id);
              if (!context.mounted) return;
              if (success) {
                Get.showSnackbar(
                  const GetSnackBar(
                    messageText: Text(
                      'Connection dropped and both profiles unlocked.',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
                onViewerClosed?.call();
              } else {
                Get.showSnackbar(
                  GetSnackBar(
                    messageText: Text(
                      provider.errorMessage ?? 'Failed to unlock connection',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Unlock & End Discussion',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaliField extends StatelessWidget {
  final String label;
  final String value;

  const _WaliField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
