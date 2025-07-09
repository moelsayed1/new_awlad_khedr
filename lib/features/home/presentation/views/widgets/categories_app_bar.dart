import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/app_router.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CategoriesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoriesAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
    Widget build(BuildContext context) {
      return AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    child: Text(
                      'الأصنـــاف',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont,
                      ),
                    ),
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kCategoriesPage);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Builder(
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: Image.asset(
                    AssetsData.back,
                    height: 45,
                    width: 45,
                  ),
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                ),
                const Text(
                  'للرجوع',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: baseFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 130,
        centerTitle: true,
        titleSpacing: 0,
      );
    }
}
