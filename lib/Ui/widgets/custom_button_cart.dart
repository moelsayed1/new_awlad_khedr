import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant.dart';

class CustomButtonCart extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final double fontSize;
  final bool isLoading;
  final bool isEnabled;

  const CustomButtonCart({
    super.key,
    required this.onTap,
    required this.text,
    this.width = double.infinity,
    this.height = 50,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height.h,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? color : Colors.grey,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont,
                ),
              ),
      ),
    );
  }
} 