import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/choice_mappings.dart';
import '../../../../providers/matches_provider.dart';
import '../widgets/match_card.dart';
import '../widgets/upgrade_subscription_dialog.dart';
import 'package:get/get.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    _loadWishlists();
  }

  Future<void> _loadWishlists() async {
    final provider = context.read<MatchesProvider>();
    await Future.wait([
      provider.loadWishlists(),
      provider.loadSentRequests(),
      provider.loadMatches(),
      provider.fetchConnectionUsage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final matchesProvider = context.watch<MatchesProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text(
          'Saved Profiles',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadWishlists,
        child: matchesProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : matchesProvider.wishlists.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_outline,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No saved profiles',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Profiles you save will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: matchesProvider.wishlists.length,
                    itemBuilder: (context, index) {
                      final wishlist = matchesProvider.wishlists[index];
                      
                      final profileId =
                          (wishlist['user_id'] ?? wishlist['id'])?.toString() ??
                              '';
                      final isConnected = profileId.isNotEmpty &&
                          matchesProvider.hasActiveConnectionWith(profileId);
                      final isRequestSent = !isConnected &&
                          profileId.isNotEmpty &&
                          matchesProvider.hasPendingSentRequestTo(profileId);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: MatchCard(
                          username: wishlist['codename'] ?? 'User',
                          isVerified: wishlist['is_verified'] == true,
                          age: wishlist['age'] != null
                              ? '${wishlist['age']} Years old'
                              : 'N/A',
                          ethnicity: wishlist['ethnicity'] != null
                              ? ChoiceMappings.keysStringToDisplay(
                                  wishlist['ethnicity'].toString(),
                                  ChoiceMappings.ethnicityKeyToDisplay,
                                )
                              : 'N/A',
                          country: wishlist['country'] ?? 'N/A',
                          imageUrl: null,
                          photos: (wishlist['photos'] as List?) ?? [],
                          lockMessage: isConnected
                              ? 'Open profile to view photos safely'
                              : 'Photos will be revealed after mutual interest',
                          isLocked: true,
                          isBlurred: true,
                          isWishlisted: true,
                          isConnected: isConnected,
                          isRequestSent: isRequestSent,
                          onWishlistToggle: () async {
                            await matchesProvider.removeFromWishlist(
                              wishlist['user_id'] ?? wishlist['id'],
                            );
                          },
                          onViewProfile: () {
                            context
                                .push(
                                  '/profile-view-details/${wishlist['user_id'] ?? wishlist['id']}',
                                )
                                .then((_) {
                              if (mounted) _loadWishlists();
                            });
                          },
                          onSendInterest: () async {
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

                            final success = await matchesProvider
                                .sendConnectionRequest(
                              wishlist['user_id'] ?? wishlist['id'],
                            );

                            if (!mounted) return;

                            if (success) {
                              Get.showSnackbar(
                                const GetSnackBar(
                                  snackPosition: SnackPosition.TOP,
                                  margin: EdgeInsets.all(16),
                                  borderRadius: 8,
                                  duration: Duration(seconds: 3),
                                  messageText: Text('Interest sent!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
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
                                  messageText: Text(
                                    matchesProvider.errorMessage ??
                                        'Failed to send',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
