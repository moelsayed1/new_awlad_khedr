import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/app_router.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                mainColor,
                Colors.white,
              ],
            )),
            child: Padding(
              padding: EdgeInsets.all(22.0.r),
              child: Center(
                  child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.0.h),
                  child: Image.asset(
                    AssetsData.logoPng,
                    width: 106.w,
                    height: 116.h,
                  ),
                ),
                //  SizedBox(
                //   height: 30.h,
                // ),
                 Center(
                  child: Text(
                    'أبدأ معنا تجارتك الأن',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40.sp,
                        fontFamily: 'GE Dinar One',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                 SizedBox(
                  height: 6.h,
                ),
                 Text(
                  'أولاد خضر للتجارة والتوزيع نحن نسعي لإرضاء عملائنا الكرام وتوفير كل إحتياجاتهم',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GE Dinar One',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*.4,                      height: 60,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kLoginView);
                        },
                        child: Center(
                            child: Text(
                          'الدخول',
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: baseFont),
                        )),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*.4,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kRegisterView);
                        },
                        child: const Center(
                          child: Text(
                            'سجل الأن',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: baseFont,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ])),
            ),
          ),
        ),
      ),
    );
  }
}
