import 'package:flutter/material.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const SearchWidget({super.key, this.controller, this.onChanged});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: 'أبحث عن منتجاتك',
          hintStyle: TextStyle(
            fontFamily: baseFont,
            color: Colors.grey[600],
          ),
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
