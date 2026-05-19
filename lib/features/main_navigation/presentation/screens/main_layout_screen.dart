import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget child;

  const MainLayoutScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the route
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/browse')) {
      currentIndex = 1;
    } else if (location.startsWith('/requests')) {
      currentIndex = 2;
    } else if (location.startsWith('/profile')) {
      currentIndex = 3;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          child,
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 8,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.secondary, Theme.of(context).primaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(
                    icon: Icons.home_filled,
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () => context.go('/home'),
                  ),
                  _NavItem(
                    icon: Icons.search,
                    label: 'Browse',
                    isSelected: currentIndex == 1,
                    onTap: () => context.go('/browse'),
                  ),
                  _NavItem(
                    icon: Icons.group_add,
                    label: 'Request',
                    isSelected: currentIndex == 2,
                    onTap: () => context.go('/requests'),
                  ),
                  _NavItem(
                    icon: Icons.person,
                    label: 'Profile',
                    isSelected: currentIndex == 3,
                    onTap: () => context.go('/profile'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
