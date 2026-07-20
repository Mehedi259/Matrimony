import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String username;
  final String age;
  final String height;
  final String profession;
  final String? imageUrl;
  final List<dynamic> photos;
  final bool isLocked;
  final String lockMessage;
  final VoidCallback? onViewProfile;
  final VoidCallback? onSendInterest;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onCancelRequest;
  final bool isExclusive;
  final String? exclusiveOverlayText;
  final bool isMatched;
  final String? matchedButtonText;
  final VoidCallback? onMatchedButtonPressed;
  final bool isBlurred;
  final bool isWishlisted;
  final VoidCallback? onWishlistToggle;

  const MatchCard({
    super.key,
    required this.username,
    required this.age,
    required this.height,
    required this.profession,
    this.imageUrl,
    this.photos = const [],
    this.isLocked = true,
    required this.lockMessage,
    this.onViewProfile,
    this.onSendInterest,
    this.onAccept,
    this.onDecline,
    this.onCancelRequest,
    this.isExclusive = false,
    this.exclusiveOverlayText,
    this.isMatched = false,
    this.matchedButtonText,
    this.onMatchedButtonPressed,
    this.isBlurred = true,
    this.isWishlisted = false,
    this.onWishlistToggle,
  });

  void _showPhotoGallery(BuildContext context) {
    if (photos.isEmpty) return;
    
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black,
      barrierDismissible: true,
      barrierLabel: 'Close',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              '${photos.length} Photos',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: PageView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Image.network(
                photos[index]['image'] ?? photos[index].imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.error_outline, color: Colors.white, size: 40),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300], // Placeholder for image
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: imageUrl != null
              ? NetworkImage(imageUrl!) as ImageProvider
              : AssetImage(
                  isBlurred
                      ? 'assets/blurredProfile1.png'
                      : 'assets/blurredProfile1.png'), // Use blurredProfile2 for matched profiles
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Dark blur overlay mock
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isBlurred ? Colors.black.withValues(alpha: 0.3) : Colors.transparent,
                  Colors.black.withValues(alpha: 0.7), // Always dark at bottom for text
                ],
              ),
            ),
          ),
          
            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isExclusive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_border, color: Colors.amber[700], size: 16),
                              const SizedBox(width: 4),
                              Text('Exclusive Match', style: TextStyle(color: Colors.amber[700], fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        )
                      else if (!isMatched)
                        GestureDetector(
                          onTap: onWishlistToggle,
                          child: Icon(
                            Icons.favorite, 
                            color: isWishlisted ? Colors.redAccent : Colors.white, 
                            size: 28,
                          ),
                        )
                      else
                        const SizedBox(), // Empty for match
                      
                      if (photos.isNotEmpty)
                        GestureDetector(
                          onTap: () => _showPhotoGallery(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.photo_library_outlined, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text('${photos.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  if (exclusiveOverlayText != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        exclusiveOverlayText!,
                        style: const TextStyle(color: Colors.black87, fontSize: 12, height: 1.4),
                      ),
                    ),
                  ],
                  
                  const Spacer(),
                  
                  // Lock Center
                  if (isLocked && !isMatched)
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.lock_outline, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lockMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    
                  if (!isMatched) const Spacer(),
                  
                  // User Details & Buttons
                  if (isMatched)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(username, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('• $age  • $height', style: const TextStyle(color: Colors.white, fontSize: 12)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.work, color: Colors.white, size: 12),
                                  const SizedBox(width: 4),
                                  Text(profession, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (matchedButtonText != null)
                          ElevatedButton(
                            onPressed: onMatchedButtonPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: Text(matchedButtonText!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                      ],
                    )
                  else if (username.isNotEmpty) ...[
                    Text(username, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('• $age  • $height', style: const TextStyle(color: Colors.white, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.work, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(profession, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Buttons
                  if (!isMatched)
                    if (onAccept != null && onDecline != null)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onDecline,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF15A68), // Reddish pink
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Decline', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onAccept,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5A75F1), // Blue
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                    else if (onCancelRequest != null && onViewProfile != null)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onCancelRequest,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF15A68),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Cancel Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onViewProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5A75F1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('View Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                        ],
                      )
                    else if (onViewProfile != null && onSendInterest != null)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onViewProfile,
                              icon: const Icon(Icons.fit_screen, size: 16, color: Colors.white),
                              label: const Text('View Profile', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onSendInterest,
                              icon: Icon(Icons.favorite, size: 16, color: Theme.of(context).primaryColor),
                              label: Text('Send Interest', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (isLocked && username.isEmpty)
                      // Blurred buttons for "Suggested for you" generic locked card
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
