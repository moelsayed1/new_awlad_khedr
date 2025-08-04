import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../../../core/app_router.dart';
import '../../../auth/login/data/provider/login_provider.dart';
import 'package:awlad_khedr/features/my_information/presentation/views/my_information_logic.dart';
import '../../../../main.dart';
import '../../controller/notification_provider.dart';

class CustomDrawer extends StatefulWidget {
  final VoidCallback? onUserInfoUpdated;
  
  const CustomDrawer({super.key, this.onUserInfoUpdated});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String selectedPage = '';
  CustomerInfo? customerInfo;
  bool isLoadingInfo = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  // Method to refresh user info (can be called from other screens)
  Future<void> refreshUserInfo() async {
    await _fetchUserInfo();
    // Notify parent widget that user info was updated
    widget.onUserInfoUpdated?.call();
  }

  Future<void> _fetchUserInfo() async {
    // First try to get cached data for immediate display
    final cachedInfo = await MyInformationLogic.getCachedCustomerInfo();
    if (cachedInfo != null) {
      setState(() {
        customerInfo = cachedInfo;
        isLoadingInfo = false;
      });
    }
    
    // Then fetch fresh data from API
    final info = await MyInformationLogic.fetchCustomerInfo(authToken);
    if (info != null) {
      // Only update if the API data is newer or different from cached data
      final currentCachedInfo = await MyInformationLogic.getCachedCustomerInfo();
      bool shouldUpdate = true;
      
      if (currentCachedInfo != null) {
        // Check if API data is actually newer (has more recent changes)
        // For now, we'll prioritize cached data if it's different from API
        // This prevents old API data from overwriting recent updates
        if (currentCachedInfo.name != info.name || 
            currentCachedInfo.email != info.email ||
            currentCachedInfo.phone != info.phone) {
          // If cached data is different, keep the cached data (it's more recent)
          log('Drawer: Keeping cached data as it appears more recent than API data');
          shouldUpdate = false;
        }
      }
      
      if (shouldUpdate) {
        setState(() {
          customerInfo = info;
          isLoadingInfo = false;
        });
        
        // Save the fresh data to cache
        await MyInformationLogic.saveCustomerInfoLocally(info);
      } else {
        setState(() {
          isLoadingInfo = false;
        });
      }
    } else {
      setState(() {
        isLoadingInfo = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (isLoadingInfo)
                            SizedBox(
                              width: 80.w,
                              height: 18.h,
                              child: LinearProgressIndicator(),
                            )
                          else ...[
                            Text(
                              customerInfo?.name ?? 'اسم المستخدم',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              customerInfo?.email ?? 'user@email.com',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500),
                            ),
                          ]
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 30.w,
                        backgroundColor: mainColor,
                        child: isLoadingInfo
                            ? CircularProgressIndicator(color: Colors.white)
                            : (customerInfo?.profilePhoto != null &&
                                    customerInfo!.profilePhoto!.isNotEmpty)
                                ? ClipOval(
                                    child: Image.network(
                                      customerInfo!.profilePhoto!,
                                      width: 50.w,
                                      height: 50.w,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        AssetsData.profile,
                                        width: 40.w,
                                        height: 40.w,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    AssetsData.profile,
                                    width: 40.w,
                                    height: 40.w,
                                  ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: Color(0xffFDA479),
                            ),
                            child: Consumer<NotificationProvider>(
                              builder: (context, notificationProvider, child) {
                                final unreadCount = notificationProvider.unreadCount;
                                return ListTile(
                                  leading: Stack(
                                    children: [
                                      Image.asset(
                                        AssetsData.alert,
                                        width: 25.w,
                                        height: 25.w,
                                        color: Colors.black,
                                      ),
                                      if (unreadCount > 0)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(2.w),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(10.w),
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 16.w,
                                              minHeight: 16.w,
                                            ),
                                            child: Text(
                                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  title: Text(
                                    'الإشعارات',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  trailing: unreadCount > 0
                                      ? Container(
                                          width: 25.w,
                                          height: 25.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    GoRouter.of(context).push(AppRouter.kNotificationPage);
                                  },
                                );
                              },
                            ),
                          )),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListTile(
                          leading: Image.asset(
                            AssetsData.data,
                            width: 25.w,
                            height: 25.w,
                          ),
                          title: Text(
                            'بياناتي ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                          onTap: () {
                            GoRouter.of(context).push(AppRouter.kMyInformation);
                          },
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListTile(
                          leading: Image.asset(
                            AssetsData.account,
                            width: 25.w,
                            height: 25.w,
                          ),
                          title: Text(
                            'حساباتي ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                          onTap: () {
                            GoRouter.of(context).push(AppRouter.kMyAccounts);
                          },
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListTile(
                          leading: Image.asset(
                            AssetsData.returnPng,
                            width: 25.w,
                            height: 25.w,
                          ),
                          title: Text(
                            'الطلبات ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                          onTap: () {
                            GoRouter.of(context)
                                .push(AppRouter.kOrdersViewPage);
                          },
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListTile(
                          leading: Image.asset(
                            AssetsData.call,
                            width: 25.w,
                            height: 25.w,
                          ),
                          title: Text(
                            'اتصل بنا',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: Image.asset(
                                AssetsData.callCenter2,
                                width: 100.w,
                                height: 100.w,
                              ),
                              content: Text(
                                '+20 1546546464\nتواصل معنا',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.sp,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: InkWell(
                    onTap: () {
                      final loginProvider =
                          Provider.of<LoginProvider>(context, listen: false);
                      loginProvider.logout();

                      GoRouter.of(context)
                          .pushReplacement(AppRouter.kLoginView);
                      log("TOOOOkEEEEEEEN${loginProvider.token.toString()}");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Image.asset(
                            AssetsData.logout,
                            width: 15.w,
                            height: 15.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
