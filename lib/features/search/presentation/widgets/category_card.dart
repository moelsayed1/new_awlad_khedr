import 'package:flutter/material.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? darkOrange : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isSelected ? darkOrange : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category,
              size: 16.sp,
              color: isSelected ? Colors.white : darkOrange,
            ),
            SizedBox(width: 6.w),
            Text(
              categoryName,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontFamily: baseFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 