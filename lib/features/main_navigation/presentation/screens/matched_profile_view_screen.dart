import 'package:flutter/material.dart';
import 'dart:ui' as dart_ui;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/matches_provider.dart';
import '../../../../data/models/matches/match_profile_model.dart';
import 'package:get/get.dart';
import 'dart:async';

class MatchedProfileViewScreen extends StatefulWidget {
  final String matchId;
  const MatchedProfileViewScreen({super.key, required this.matchId});

  @override
  State<MatchedProfileViewScreen> createState() => _MatchedProfileViewScreenState();
}

class _MatchedProfileViewScreenState extends State<MatchedProfileViewScreen> {
  bool? _initialIsBlurred;
  int _currentPhotoIndex = 0;
  
  int _secondsLeft = 60;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MatchesProvider>();
      if (provider.matches.isEmpty) {
        provider.loadMatches();
      }
    });
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
    final isFemaleOrWali = authUser?.role.toLowerCase() == 'female' || authUser?.role.toLowerCase() == 'wali' || authUser?.gender?.toLowerCase() == 'female';
    
    if (_initialIsBlurred == null) {
      _initialIsBlurred = isFemaleOrWali ? false : true;
    }
    final bool isBlurred = _initialIsBlurred!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile View', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).primaryColor),
            onPressed: () {},
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
            onPressed: () {},
          ),
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
                      Widget imageContainer = Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: DecorationImage(
                            image: match.matchedUserPhotos.isNotEmpty
                                ? NetworkImage(match.matchedUserPhotos[index]['image']) as ImageProvider
                                : const AssetImage('assets/placeholder_profile.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                      
                      if (isBlurred) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              imageContainer,
                              BackdropFilter(
                                filter: ColorFilter.mode(
                                  Colors.white.withOpacity(0.1),
                                  BlendMode.srcOver,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              BackdropFilter(
                                filter: dart_ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return imageContainer;
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
            
            // Info Banner
            if (isBlurred && !isFemaleOrWali)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMaleInfoText(match),
                          const SizedBox(height: 8),
                          _buildMaleActionButton(context, match),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
            // Approve/Decline Photo Request Banner
            if (match.photoRequestStatus == 'requested' && match.photoRequestedByOtherUser)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.photo_camera_front, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Photo Request', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      match.secondPhotoRequestStatus == 'pending' 
                        ? '$name has requested a second and final 60-second window to view your photos.'
                        : '$name has requested to view your photos for 60 seconds.',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await context.read<MatchesProvider>().respondToPhotoRequest(matchId: match.id, accept: false);
                            },
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Decline'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await context.read<MatchesProvider>().respondToPhotoRequest(matchId: match.id, accept: true);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Approve'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            
            // Wali Details Card
            if (match.waliRequestStatus == 'approved')
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF8EB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person_outline, size: 18),
                        SizedBox(width: 8),
                        Text('Wali Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _DetailItem(label: 'Wali name', value: otherUser['wali_name'] ?? 'N/A')),
                        Expanded(child: _DetailItem(label: 'Wali number', value: otherUser['wali_phone'] ?? 'N/A')),
                      ],
                    ),
                  ],
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

  Widget _buildMaleInfoText(MatchModel match) {
    if (match.photoViewCount == 0) {
      if (match.photosCurrentlyVisible) return const Text('Photos unlocked! You have 60 seconds to view them.', style: TextStyle(color: Colors.black87, fontSize: 13));
      if (match.photoRequestStatus == 'requested') return const Text('Photo request sent. Waiting for approval.', style: TextStyle(color: Colors.black87, fontSize: 13));
      if (match.photoRequestStatus == 'rejected') return const Text('Your photo request was declined.', style: TextStyle(color: Colors.black87, fontSize: 13));
      return const Text('Request to view photos for 60 seconds.', style: TextStyle(color: Colors.black87, fontSize: 13));
    }
    
    if (match.photoViewCount == 1) {
      if (match.photosCurrentlyVisible) return const Text('Photos unlocked! This is your final 60-second view.', style: TextStyle(color: Colors.black87, fontSize: 13));
      if (match.secondPhotoRequestStatus == 'pending') return const Text('Second photo request sent. Waiting for approval.', style: TextStyle(color: Colors.black87, fontSize: 13));
      if (match.secondPhotoRequestStatus == 'rejected') return const Text('Your second photo request was declined.', style: TextStyle(color: Colors.black87, fontSize: 13));
      return const Text('Your initial viewing time has expired.', style: TextStyle(color: Colors.black87, fontSize: 13));
    }
    
    return const Text('You have used both of your photo viewing opportunities.', style: TextStyle(color: Colors.black87, fontSize: 13));
  }

  Widget _buildMaleActionButton(BuildContext context, MatchModel match) {
    String buttonText = '';
    VoidCallback? onPressed;

    if (match.photosCurrentlyVisible) {
      buttonText = match.photoViewCount == 0 ? 'View Photos (60s)' : 'View Photos (Final 60s)';
      onPressed = () {
        if (match.matchedUserPhotos.isNotEmpty) {
          _startPhotoTimer(match.matchedUserPhotos, match.id);
        } else {
          Get.showSnackbar(const GetSnackBar(messageText: Text('No photos available'), duration: Duration(seconds: 2)));
        }
      };
    } else if (match.photoViewCount == 0 && match.photoRequestStatus == 'none') {
      buttonText = 'Request to view photos';
      onPressed = () async {
        final success = await context.read<MatchesProvider>().requestPhotoView(match.id);
        if (success && context.mounted) {
          Get.showSnackbar(const GetSnackBar(messageText: Text('Photo request sent successfully'), backgroundColor: Colors.green, duration: Duration(seconds: 3)));
        }
      };
    } else if (match.photoViewCount == 1 && match.secondPhotoRequestStatus == 'none') {
      buttonText = 'Request a second view';
      onPressed = () async {
        final success = await context.read<MatchesProvider>().requestPhotoView(match.id);
        if (success && context.mounted) {
          Get.showSnackbar(const GetSnackBar(messageText: Text('Second photo request sent successfully'), backgroundColor: Colors.green, duration: Duration(seconds: 3)));
        }
      };
    }

    if (buttonText.isEmpty) return const SizedBox.shrink();

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(buttonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  void _startPhotoTimer(List<dynamic> photos, String matchId) {
    // Notify backend that photos are being viewed to start the lockdown
    context.read<MatchesProvider>().markPhotosViewed(matchId);
    
    setState(() {
      _secondsLeft = 60;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            if (_timer == null || !_timer!.isActive) {
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (_secondsLeft > 0) {
                  setStateDialog(() {
                    _secondsLeft--;
                  });
                } else {
                  timer.cancel();
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                }
              });
            }
            
            return Dialog.fullscreen(
              backgroundColor: Colors.black,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return Image.network(photos[index]['image'], fit: BoxFit.contain);
                    },
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                      child: Text('Time left: $_secondsLeft s', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () {
                        _timer?.cancel();
                        Navigator.of(context).pop();
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
      _timer?.cancel();
      setState(() {});
    });
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
