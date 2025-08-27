import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_dropdown_widget.dart';
import './widgets/course_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/selected_category_display_widget.dart';

class CoursesList extends StatefulWidget {
  const CoursesList({super.key});

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All Categories';
  String _searchQuery = '';
  bool _isLoading = false;
  late ScrollController _scrollController;

  final List<String> _categories = [
    'All Categories',
    'Science',
    'Arts',
    'Technology',
    'Business',
    'Health',
    'Language',
  ];

  final List<Map<String, dynamic>> _allCourses = [
    {
      "id": 1,
      "name": "Introduction to Data Science",
      "instructor": "Dr. Sarah Johnson",
      "category": "Science",
      "icon": "analytics",
      "description":
          "Learn the fundamentals of data analysis, statistics, and machine learning with hands-on projects.",
      "rating": 4.8,
      "duration": "12 weeks",
      "isEnrolled": false,
      "image":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "name": "Digital Art Fundamentals",
      "instructor": "Maria Rodriguez",
      "category": "Arts",
      "icon": "brush",
      "description":
          "Master digital painting techniques and create stunning artwork using professional tools.",
      "rating": 4.6,
      "duration": "8 weeks",
      "isEnrolled": true,
      "image":
          "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "name": "Mobile App Development",
      "instructor": "James Chen",
      "category": "Technology",
      "icon": "phone_android",
      "description":
          "Build cross-platform mobile applications using Flutter and modern development practices.",
      "rating": 4.9,
      "duration": "16 weeks",
      "isEnrolled": false,
      "image":
          "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 4,
      "name": "Business Strategy & Leadership",
      "instructor": "Prof. Michael Thompson",
      "category": "Business",
      "icon": "business_center",
      "description":
          "Develop strategic thinking skills and learn effective leadership techniques for modern organizations.",
      "rating": 4.7,
      "duration": "10 weeks",
      "isEnrolled": false,
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 5,
      "name": "Nutrition & Wellness",
      "instructor": "Dr. Emily Davis",
      "category": "Health",
      "icon": "favorite",
      "description":
          "Understand the science of nutrition and create sustainable wellness habits for a healthier lifestyle.",
      "rating": 4.5,
      "duration": "6 weeks",
      "isEnrolled": true,
      "image":
          "https://images.unsplash.com/photo-1490645935967-10de6ba17061?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 6,
      "name": "Spanish for Beginners",
      "instructor": "Carlos Martinez",
      "category": "Language",
      "icon": "translate",
      "description":
          "Start your Spanish learning journey with interactive lessons and practical conversation practice.",
      "rating": 4.4,
      "duration": "14 weeks",
      "isEnrolled": false,
      "image":
          "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 7,
      "name": "Advanced Physics",
      "instructor": "Dr. Robert Wilson",
      "category": "Science",
      "icon": "science",
      "description":
          "Explore quantum mechanics, relativity, and modern physics concepts with mathematical rigor.",
      "rating": 4.3,
      "duration": "18 weeks",
      "isEnrolled": false,
      "image":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 8,
      "name": "Web Development Bootcamp",
      "instructor": "Lisa Park",
      "category": "Technology",
      "icon": "web",
      "description":
          "Learn full-stack web development from HTML/CSS to advanced frameworks and deployment.",
      "rating": 4.8,
      "duration": "20 weeks",
      "isEnrolled": true,
      "image":
          "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCourses {
    List<Map<String, dynamic>> filtered = _allCourses;

    // Filter by category
    if (_selectedCategory != 'All Categories') {
      filtered = filtered
          .where((course) =>
              (course["category"] as String).toLowerCase() ==
              _selectedCategory.toLowerCase())
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((course) {
        final name = (course["name"] as String).toLowerCase();
        final instructor = (course["instructor"] as String).toLowerCase();
        final description = (course["description"] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            instructor.contains(query) ||
            description.contains(query);
      }).toList();
    }

    return filtered;
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _scrollToTop();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _resetFilter() {
    setState(() {
      _selectedCategory = 'All Categories';
      _searchQuery = '';
    });
    _scrollToTop();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();
  }

  void _onCourseEnroll(Map<String, dynamic> course) {
    final courseName = course["name"] as String;
    final isEnrolled = course["isEnrolled"] as bool;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEnrolled
              ? 'Successfully enrolled in $courseName!'
              : 'Unenrolled from $courseName',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onCourseTap(Map<String, dynamic> course) {
    HapticFeedback.selectionClick();
    // Navigate to course details
    // Navigator.pushNamed(context, '/course-details', arguments: course);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          content: Text(
            'Are you sure you want to exit the app?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
              child: Text(
                'Yes',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredCourses = _filteredCourses;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Courses',
        actions: [
          IconButton(
            onPressed: _showLogoutDialog,
            icon: CustomIconWidget(
              iconName: 'logout',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Active tab indicator
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'school',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Courses Tab Active',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            SearchBarWidget(
              searchQuery: _searchQuery,
              onSearchChanged: _onSearchChanged,
            ),

            // Category dropdown
            CategoryDropdownWidget(
              selectedCategory: _selectedCategory,
              categories: _categories,
              onCategoryChanged: _onCategoryChanged,
            ),

            // Selected category display
            SelectedCategoryDisplayWidget(
              selectedCategory: _selectedCategory,
              courseCount: filteredCourses.length,
            ),

            SizedBox(height: 1.h),

            // Course list
            Expanded(
              child: filteredCourses.isEmpty
                  ? EmptyStateWidget(
                      selectedCategory: _selectedCategory,
                      onResetFilter: _resetFilter,
                    )
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: theme.colorScheme.primary,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 2.h),
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];
                          return CourseCardWidget(
                            course: course,
                            onTap: () => _onCourseTap(course),
                            onEnroll: () => _onCourseEnroll(course),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 1, // Courses tab
        onTap: (index) {
          HapticFeedback.selectionClick();
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home-dashboard');
              break;
            case 1:
              // Already on courses list
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/user-profile');
              break;
          }
        },
      ),
    );
  }
}