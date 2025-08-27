import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activities = _getRecentActivities();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final activity = activities[index];
            return _buildActivityCard(context, activity);
          },
        ),
      ],
    );
  }

  Widget _buildActivityCard(
      BuildContext context, Map<String, dynamic> activity) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getActivityColor(activity['type'] as String, theme),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getActivityIcon(activity['type'] as String),
              color: theme.colorScheme.surface,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity['description'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity['time'] as String,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (activity['progress'] != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${activity['progress']}%',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getActivityColor(String type, ThemeData theme) {
    switch (type) {
      case 'progress':
        return theme.colorScheme.primary;
      case 'completion':
        return Colors.green;
      case 'announcement':
        return theme.colorScheme.tertiary;
      case 'assignment':
        return Colors.orange;
      default:
        return theme.colorScheme.secondary;
    }
  }

  String _getActivityIcon(String type) {
    switch (type) {
      case 'progress':
        return 'trending_up';
      case 'completion':
        return 'check_circle';
      case 'announcement':
        return 'campaign';
      case 'assignment':
        return 'assignment';
      default:
        return 'info';
    }
  }

  List<Map<String, dynamic>> _getRecentActivities() {
    return [
      {
        "id": 1,
        "type": "progress",
        "title": "Flutter Development Progress",
        "description": "You've completed Module 3: State Management",
        "time": "2 hours ago",
        "progress": 75,
      },
      {
        "id": 2,
        "type": "completion",
        "title": "Digital Art Fundamentals",
        "description": "Congratulations! You've completed the course",
        "time": "1 day ago",
        "progress": null,
      },
      {
        "id": 3,
        "type": "announcement",
        "title": "New Course Available",
        "description": "Advanced Machine Learning course is now live",
        "time": "2 days ago",
        "progress": null,
      },
      {
        "id": 4,
        "type": "assignment",
        "title": "Physics Assignment Due",
        "description": "Submit your lab report by tomorrow",
        "time": "3 days ago",
        "progress": null,
      },
    ];
  }
}
