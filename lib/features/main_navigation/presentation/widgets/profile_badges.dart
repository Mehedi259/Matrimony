import 'package:flutter/material.dart';

/// Displays a member's codename alongside a crisp blue verification badge when verified.
class VerifiedCodename extends StatelessWidget {
  final String codename;
  final bool isVerified;
  final TextStyle? style;
  final double iconSize;
  final int? maxLines;
  final TextOverflow? overflow;

  const VerifiedCodename({
    super.key,
    required this.codename,
    required this.isVerified,
    this.style,
    this.iconSize = 18,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            codename,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),
        if (isVerified) ...[
          const SizedBox(width: 4),
          Tooltip(
            message: 'Verified Profile',
            child: Icon(
              Icons.verified,
              color: const Color(0xFF1D9BF0),
              size: iconSize,
            ),
          ),
        ],
      ],
    );
  }
}

/// Displays either a green "Online" pill or the offline last-active label ("Active X hr/day ago").
class OnlineStatusBadge extends StatelessWidget {
  final bool isOnline;
  final String? offlineLabel;

  const OnlineStatusBadge({
    super.key,
    required this.isOnline,
    this.offlineLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: const Text(
          'Online',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final text = offlineLabel?.trim();
    if (text == null || text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, size: 12, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

