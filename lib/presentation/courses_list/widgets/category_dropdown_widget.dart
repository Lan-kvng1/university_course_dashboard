import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CategoryDropdownWidget extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onCategoryChanged;

  const CategoryDropdownWidget({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: true,
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          elevation: 8,
          onChanged: (String? newValue) {
            if (newValue != null && newValue != selectedCategory) {
              HapticFeedback.selectionClick();
              onCategoryChanged(newValue);
            }
          },
          items: categories.map<DropdownMenuItem<String>>((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: _getCategoryIcon(category),
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      category,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: selectedCategory == category
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (selectedCategory == category)
                    CustomIconWidget(
                      iconName: 'check',
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all categories':
        return 'apps';
      case 'science':
        return 'science';
      case 'arts':
        return 'palette';
      case 'technology':
        return 'computer';
      case 'business':
        return 'business';
      case 'health':
        return 'health_and_safety';
      case 'language':
        return 'translate';
      default:
        return 'category';
    }
  }
}
