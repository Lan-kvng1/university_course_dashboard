import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/account_settings_section.dart';
import './widgets/achievement_badges_section.dart';
import './widgets/enrolled_courses_list.dart';
import './widgets/user_avatar_section.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;
  bool _isRefreshing = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
    "membershipType": "Premium Student",
    "enrolledCourses": 8,
    "completedCourses": 5,
    "certificates": 3,
    "joinDate": "January 2024",
  };

  final List<Map<String, dynamic>> enrolledCourses = [
    {
      "id": 1,
      "title": "Advanced Flutter Development",
      "instructor": "Dr. Michael Chen",
      "icon": "https://cdn-icons-png.flaticon.com/512/5968/5968350.png",
      "progress": 0.75,
      "status": "In Progress",
      "duration": "12 weeks",
      "nextLesson": "State Management with Riverpod",
    },
    {
      "id": 2,
      "title": "UI/UX Design Fundamentals",
      "instructor": "Emma Rodriguez",
      "icon": "https://cdn-icons-png.flaticon.com/512/3281/3281289.png",
      "progress": 1.0,
      "status": "Completed",
      "duration": "8 weeks",
      "completedDate": "March 15, 2024",
    },
    {
      "id": 3,
      "title": "Data Science with Python",
      "instructor": "Prof. James Wilson",
      "icon": "https://cdn-icons-png.flaticon.com/512/5968/5968350.png",
      "progress": 0.45,
      "status": "In Progress",
      "duration": "16 weeks",
      "nextLesson": "Machine Learning Basics",
    },
    {
      "id": 4,
      "title": "Digital Marketing Strategy",
      "instructor": "Lisa Thompson",
      "icon": "https://cdn-icons-png.flaticon.com/512/3281/3281289.png",
      "progress": 0.0,
      "status": "Not Started",
      "duration": "10 weeks",
      "startDate": "April 1, 2024",
    },
  ];

  final List<Map<String, dynamic>> achievements = [
    {
      "id": 1,
      "title": "First Course",
      "description": "Complete your first course",
      "icon": "school",
      "unlocked": true,
      "earnedDate": "Feb 2024",
    },
    {
      "id": 2,
      "title": "Quick Learner",
      "description": "Complete 3 courses in one month",
      "icon": "flash_on",
      "unlocked": true,
      "earnedDate": "Mar 2024",
    },
    {
      "id": 3,
      "title": "Dedicated Student",
      "description": "Study for 30 consecutive days",
      "icon": "local_fire_department",
      "unlocked": false,
      "earnedDate": "",
    },
    {
      "id": 4,
      "title": "Expert Level",
      "description": "Complete 10 advanced courses",
      "icon": "workspace_premium",
      "unlocked": false,
      "earnedDate": "",
    },
    {
      "id": 5,
      "title": "Community Helper",
      "description": "Help 50 fellow students",
      "icon": "people",
      "unlocked": true,
      "earnedDate": "Mar 2024",
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    _refreshController.reverse();

    setState(() {
      _isRefreshing = false;
    });

    // Show success feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showLogoutDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _exitApp();
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exitApp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  void _exitApp() {
    HapticFeedback.mediumImpact();
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
          statusBarBrightness: theme.brightness,
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.selectionClick();
              // Navigate to advanced settings
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active tab indicator
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Profile Tab Active',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // User Avatar Section
              UserAvatarSection(userData: userData),

              SizedBox(height: 3.h),

              // Enrolled Courses List
              EnrolledCoursesList(enrolledCourses: enrolledCourses),

              SizedBox(height: 3.h),

              // Achievement Badges Section
              AchievementBadgesSection(achievements: achievements),

              SizedBox(height: 3.h),

              // Account Settings Section
              const AccountSettingsSection(),

              SizedBox(height: 4.h),

              // Logout Button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'logout',
                        color: theme.colorScheme.onError,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Logout',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onError,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // Footer info
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  children: [
                    Text(
                      'Member since ${userData['joinDate']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Course Dashboard v1.0.0',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
