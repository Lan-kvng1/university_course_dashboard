import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar variants for different screen contexts
enum CustomAppBarVariant {
  standard,
  search,
  profile,
  course,
}

/// Production-ready custom app bar with educational focus and platform adaptation
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final String? searchHint;
  final bool centerTitle;
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.onSearchTap,
    this.onProfileTap,
    this.searchHint,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
      leading: _buildLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: _buildActions(context),
      bottom: variant == CustomAppBarVariant.search
          ? _buildSearchBottom(context)
          : null,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.profile:
      case CustomAppBarVariant.course:
        return Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      case CustomAppBarVariant.search:
        return GestureDetector(
          onTap: onSearchTap,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  Icons.search,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    searchHint ?? 'Search courses...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (automaticallyImplyLeading && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        iconSize: 20,
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final defaultActions = <Widget>[];

    switch (variant) {
      case CustomAppBarVariant.standard:
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: 24,
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(context, '/courses-list');
            },
            tooltip: 'Search Courses',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            iconSize: 24,
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(context, '/user-profile');
            },
            tooltip: 'Profile',
          ),
        ]);
        break;
      case CustomAppBarVariant.search:
        defaultActions.add(
          IconButton(
            icon: const Icon(Icons.tune),
            iconSize: 24,
            onPressed: () {
              HapticFeedback.selectionClick();
              _showFilterDialog(context);
            },
            tooltip: 'Filter',
          ),
        );
        break;
      case CustomAppBarVariant.profile:
        defaultActions.add(
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            iconSize: 24,
            onPressed: () {
              HapticFeedback.selectionClick();
              // Navigate to settings
            },
            tooltip: 'Settings',
          ),
        );
        break;
      case CustomAppBarVariant.course:
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            iconSize: 24,
            onPressed: () {
              HapticFeedback.selectionClick();
              // Handle bookmark
            },
            tooltip: 'Bookmark',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            iconSize: 24,
            onPressed: () {
              HapticFeedback.selectionClick();
              // Handle share
            },
            tooltip: 'Share',
          ),
        ]);
        break;
    }

    // Combine custom actions with default actions
    final allActions = <Widget>[];
    if (actions != null) {
      allActions.addAll(actions!);
    }
    allActions.addAll(defaultActions);

    return allActions.isNotEmpty ? allActions : null;
  }

  PreferredSizeWidget? _buildSearchBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: Container(),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Courses'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Categories'),
              leading: Radio<String>(
                value: 'all',
                groupValue: 'all',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Programming'),
              leading: Radio<String>(
                value: 'programming',
                groupValue: 'all',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Design'),
              leading: Radio<String>(
                value: 'design',
                groupValue: 'all',
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (variant == CustomAppBarVariant.search ? 0 : 0),
      );
}

/// Factory methods for common app bar configurations
extension CustomAppBarFactory on CustomAppBar {
  /// Standard app bar for main screens
  static CustomAppBar standard({
    required String title,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.standard,
      actions: actions,
    );
  }

  /// Search-focused app bar for course discovery
  static CustomAppBar search({
    String? searchHint,
    VoidCallback? onSearchTap,
  }) {
    return CustomAppBar(
      title: '',
      variant: CustomAppBarVariant.search,
      searchHint: searchHint,
      onSearchTap: onSearchTap,
      centerTitle: false,
    );
  }

  /// Profile-specific app bar
  static CustomAppBar profile({
    required String title,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.profile,
    );
  }

  /// Course detail app bar
  static CustomAppBar course({
    required String title,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.course,
    );
  }
}
