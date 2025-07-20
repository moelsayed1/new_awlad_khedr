import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: Builder(
        builder: (context) {
          // Filter out the category named 'operation'
          final filteredCategories = categories.where((c) => c.toLowerCase() != 'operation').toList();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero, // Remove outer padding from the ListView
            itemCount: filteredCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 4),
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              final isSelected = category == selectedCategory;
              return GestureDetector(
                onTap: () => onCategorySelected(category),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0), // Minimal padding
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xffFC6E2A) : Colors.white, // Use your color for selected/unselected
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}