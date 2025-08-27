import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom bottom navigation bar with adaptive design and smooth transitions
/// Implements IndexedStack for persistent state and platform-appropriate styling
class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (index != widget.currentIndex) {
      // Subtle haptic feedback for tab transitions
      HapticFeedback.selectionClick();

      // Animate scale for tactile feedback
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: BottomNavigationBar(
                currentIndex: widget.currentIndex,
                onTap: _handleTap,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: colorScheme.primary,
                unselectedItemColor: colorScheme.onSurfaceVariant,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                iconSize: 24,
                items: [
                  BottomNavigationBarItem(
                    icon: _buildIcon(Icons.home_outlined, 0),
                    activeIcon: _buildIcon(Icons.home, 0),
                    label: 'Home',
                    tooltip: 'Home Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(Icons.school_outlined, 1),
                    activeIcon: _buildIcon(Icons.school, 1),
                    label: 'Courses',
                    tooltip: 'Browse Courses',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(Icons.person_outline, 2),
                    activeIcon: _buildIcon(Icons.person, 2),
                    label: 'Profile',
                    tooltip: 'User Profile',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    final isSelected = widget.currentIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(4),
      decoration: isSelected
          ? BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Icon(
        icon,
        size: 24,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Bottom navigation wrapper that handles route navigation
class CustomBottomNavigation extends StatefulWidget {
  final Widget child;

  const CustomBottomNavigation({
    super.key,
    required this.child,
  });

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _currentIndex = 0;

  final List<String> _routes = [
    '/home-dashboard',
    '/courses-list',
    '/user-profile',
  ];

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      // Navigate to the selected route
      Navigator.pushReplacementNamed(context, _routes[index]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update current index based on current route
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != null) {
      final index = _routes.indexOf(currentRoute);
      if (index != -1 && index != _currentIndex) {
        setState(() {
          _currentIndex = index;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
