import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedCoursesWidget extends StatelessWidget {
  final String selectedCategory;

  const FeaturedCoursesWidget({
    super.key,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredCourses = _getFilteredCourses();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Courses',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/courses-list');
              },
              child: Text(
                'View All',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredCourses.length,
            itemBuilder: (context, index) {
              final course = filteredCourses[index];
              return Container(
                width: 70.w,
                margin: EdgeInsets.only(right: 3.w),
                child: _buildCourseCard(context, course),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/courses-list');
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: CustomImageWidget(
                    imageUrl: course['image'] as String,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['name'] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 3.5.w,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            course['instructor'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            course['category'] as String,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: theme.colorScheme.tertiary,
                              size: 3.5.w,
                            ),
                            SizedBox(width: 0.5.w),
                            Text(
                              course['rating'].toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredCourses() {
    final allCourses = [
      {
        "id": 1,
        "name": "Introduction to Flutter Development",
        "instructor": "Dr. Sarah Johnson",
        "category": "Technology",
        "rating": 4.8,
        "image":
            "https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      },
      {
        "id": 2,
        "name": "Digital Art Fundamentals",
        "instructor": "Prof. Michael Chen",
        "category": "Arts",
        "rating": 4.6,
        "image":
            "https://images.pexels.com/photos/1762851/pexels-photo-1762851.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      },
      {
        "id": 3,
        "name": "Physics for Beginners",
        "instructor": "Dr. Emily Rodriguez",
        "category": "Science",
        "rating": 4.7,
        "image":
            "https://cdn.pixabay.com/photo/2017/08/30/01/05/milky-way-2695569_1280.jpg",
      },
      {
        "id": 4,
        "name": "Machine Learning Basics",
        "instructor": "Prof. David Kim",
        "category": "Technology",
        "rating": 4.9,
        "image":
            "https://images.unsplash.com/photo-1555949963-aa79dcee981c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      },
      {
        "id": 5,
        "name": "Creative Writing Workshop",
        "instructor": "Dr. Lisa Thompson",
        "category": "Arts",
        "rating": 4.5,
        "image":
            "https://images.pexels.com/photos/261763/pexels-photo-261763.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      },
      {
        "id": 6,
        "name": "Chemistry Lab Techniques",
        "instructor": "Prof. Robert Wilson",
        "category": "Science",
        "rating": 4.4,
        "image":
            "https://cdn.pixabay.com/photo/2017/07/18/15/39/laboratory-2515641_1280.jpg",
      },
    ];

    if (selectedCategory == 'All Categories') {
      return allCourses;
    }

    return (allCourses as List)
        .where((dynamic course) =>
            (course as Map<String, dynamic>)['category'] == selectedCategory)
        .cast<Map<String, dynamic>>()
        .toList();
  }
}
