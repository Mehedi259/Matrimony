import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/matches_provider.dart';
import '../widgets/match_card.dart';
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
    await context.read<MatchesProvider>().loadWishlists();
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
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: MatchCard(
                          username: wishlist['codename'] ?? 'User',
                          age: wishlist['age'] != null
                              ? '${wishlist['age']} Years old'
                              : 'N/A',
                          height: wishlist['height'] ?? 'N/A',
                          profession: wishlist['city'] ?? 'N/A',
                          photoCount: 5,
                          lockMessage: wishlist['photo_blurred'] == true
                              ? 'Photos will be revealed after mutual interest'
                              : '',
                          isLocked: wishlist['photo_blurred'] == true,
                          isWishlisted: true,
                          onWishlistToggle: () async {
                            await matchesProvider.removeFromWishlist(
                              wishlist['user_id'] ?? wishlist['id'],
                            );
                          },
                          onViewProfile: () {
                            context.push(
                              '/profile-view-details/${wishlist['user_id'] ?? wishlist['id']}',
                            );
                          },
                          onSendInterest: () async {
                            final success = await matchesProvider
                                .sendConnectionRequest(
                              wishlist['user_id'] ?? wishlist['id'],
                            );

                            if (!mounted) return;

                            if (success) {
                              Get.showSnackbar(
                                const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('Interest sent!'),
                                  backgroundColor: Colors.green,
                                ),
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
