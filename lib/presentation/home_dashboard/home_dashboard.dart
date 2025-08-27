import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/animated_enrollment_button_widget.dart';
import './widgets/category_dropdown_widget.dart';
import './widgets/featured_courses_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/welcome_header_widget.dart';
import 'widgets/animated_enrollment_button_widget.dart';
import 'widgets/category_dropdown_widget.dart';
import 'widgets/featured_courses_widget.dart';
import 'widgets/recent_activity_widget.dart';
import 'widgets/welcome_header_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  String selectedCategory = 'All Categories';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  _buildActiveTabIndicator(context),
                  SizedBox(height: 3.h),
                  WelcomeHeaderWidget(),
                  SizedBox(height: 3.h),
                  CategoryDropdownWidget(
                    onCategoryChanged: _onCategoryChanged,
                  ),
                  SizedBox(height: 3.h),
                  FeaturedCoursesWidget(
                    selectedCategory: selectedCategory,
                  ),
                  SizedBox(height: 3.h),
                  RecentActivityWidget(),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedEnrollmentButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: _onBottomNavTap,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      title: Text(
        'Course Dashboard',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'search',
            color: theme.colorScheme.onSurface,
            size: 6.w,
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pushNamed(context, '/courses-list');
          },
          tooltip: 'Search Courses',
        ),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'logout',
            color: theme.colorScheme.error,
            size: 6.w,
          ),
          onPressed: _showLogoutDialog,
          tooltip: 'Logout',
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildActiveTabIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'home',
            color: theme.colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'Home Dashboard - Active Tab',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
    });
    HapticFeedback.selectionClick();
  }

  void _onBottomNavTap(int index) {
    HapticFeedback.selectionClick();

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/courses-list');
        break;
      case 2:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();

    // Simulate refresh delay
    await Future.delayed(Duration(milliseconds: 1500));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dashboard refreshed successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLogoutDialog() {
    HapticFeedback.mediumImpact();

    if (Platform.isIOS) {
      _showCupertinoLogoutDialog();
    } else {
      _showMaterialLogoutDialog();
    }
  }

  void _showCupertinoLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              'Are you sure you want to exit the app?',
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: CupertinoColors.systemBlue,
                  fontSize: 16.sp,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                _exitApp();
              },
              isDestructiveAction: true,
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMaterialLogoutDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'logout',
                color: theme.colorScheme.error,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Logout',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to exit the app?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exitApp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _exitApp() {
    HapticFeedback.heavyImpact();

    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}