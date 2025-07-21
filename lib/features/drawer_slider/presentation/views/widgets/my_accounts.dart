import 'dart:ui' as ui;

import 'package:awlad_khedr/features/drawer_slider/presentation/views/widgets/accounts_details_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../constant.dart';
import '../../../../../core/assets.dart';
import 'package:provider/provider.dart';
import '../../../../invoice/data/invoice_provider.dart';
import 'package:intl/intl.dart';

class MyAccounts extends StatelessWidget {
  const MyAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = InvoiceProvider();
        provider.fetchTransactions();
        return provider;
      },
      child: const _MyAccountsBody(),
    );
  }
}

String formatTime(String timeString) {
  if (timeString.isEmpty) return '-';
  try {
    final dateTime = DateTime.parse(timeString);
    return DateFormat.jm().format(dateTime); // e.g., 5:08 PM
  } catch (e) {
    return '-';
  }
}

class _MyAccountsBody extends StatelessWidget {
  const _MyAccountsBody();

  @override
  Widget build(BuildContext context) {
    // Use ScreenUtil to get responsive sizes
    final double horizontalPadding = 16.w;
    final double verticalPadding = 16.h;
    final double cardHeight = 90.h;
    final double cardRadius = 20.r;
    final double iconSize = 24.sp;
    final double smallIconSize = 20.sp;
    final double cardWidth = 0.44.sw;
    final double betweenCards = 8.w; // Reduced from 12.w
    final double betweenRows = 22.h;
    final double nextPaymentWidth = 0.85.sw;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Image.asset(
                  AssetsData.back,
                  color: Colors.black,
                  width: 24.w,
                  height: 24.w,
                ),
                SizedBox(width: 4.w),
                Text(
                  'للخلف',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontFamily: baseFont,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 120.w,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'حساباتي',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: baseFont,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: cardWidth,
                    // height: cardHeight, // Let the card size itself
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: darkOrange,
                      borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Use min size
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'رصيد الاجل المتبقي',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: baseFont,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Image.asset(
                              AssetsData.account,
                              color: Colors.white,
                              width: 15.w,
                              height: 15.w,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Consumer<InvoiceProvider>(
                          builder: (context, provider, _) {
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'EGP  ${provider.allRestOfDues ?? 0}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: betweenCards),
                  Container(
                    width: cardWidth,
                    // height: cardHeight,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'اجمالي المستحقات',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: baseFont,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Image.asset(
                              AssetsData.account,
                              color: Colors.white,
                              width: 15.w,
                              height: 15.w,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Consumer<InvoiceProvider>(
                          builder: (context, provider, _) {
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'EGP  ${provider.totalReceivables ?? 0}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: betweenRows),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<InvoiceProvider>(
                    builder: (context, provider, _) {
                      if (provider.transactions.isEmpty) {
                        return SizedBox(); // Show nothing while loading
                      }
                      final nextPayment = provider.transactions.first;
                      final amount = nextPayment['rest_of_dues']?.toString() ?? '-';
                      final date = nextPayment['create_date_cus']?.toString() ?? '-';
                      final time = nextPayment['create_date']?.toString() ?? '-';
                      return Container(
                        width: nextPaymentWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
                          color: deepRed,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                          child: Column(
                            children: [
                              Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.sentiment_satisfied_alt, color: Colors.white, size: iconSize),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'الدفع القادم بعد يوم ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: baseFont,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'مطلوب دفعه',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: baseFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Text(
                                    'EGP $amount',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_month, color: Colors.white, size: smallIconSize),
                                    SizedBox(width: 8.w),
                                    Text(
                                      date,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      formatTime(time),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(Icons.access_time, color: Colors.white, size: smallIconSize),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: betweenRows),
              const CustomAccountItem(),
            ],
          ),
        ),
      ),
    );
  }
}
