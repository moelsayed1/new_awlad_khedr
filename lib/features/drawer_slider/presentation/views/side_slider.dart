import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../../../core/app_router.dart';
import '../../../auth/login/data/provider/login_provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String selectedPage = '';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'محمد عبدالرحمن ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'ashfaksayem@gmail.com',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: mainColor,
                      child: Image.asset(
                        AssetsData.profile,
                      ),
                    ),
                  ],
                ),
              ),
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
                    child: ListTile(
                        leading: Image.asset(
                          AssetsData.alert,
                          width: 25,
                          height: 25,
                          color: Colors.black,
                        ),
                        title: const Text(
                          'الإشعارات',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        trailing: Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Text(
                              '6',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                // fontFamily: baseFont,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kNotificationPage);
                        }),
                  )),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  leading: Image.asset(
                    AssetsData.data,
                    width: 25,
                    height: 25,
                  ),
                  title: const Text(
                    'بياناتي ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
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
                    width: 25,
                    height: 25,
                  ),
                  title: const Text(
                    'حساباتي ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
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
                    width: 25,
                    height: 25,
                  ),
                  title: const Text(
                    'الطلبات ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kOrdersViewPage);
                  },
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  leading: Image.asset(
                    AssetsData.call,
                    width: 25,
                    height: 25,
                  ),
                  title: const Text(
                    'اتصل بنا',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Image.asset(
                        AssetsData.callCenter2,
                        width: 100,
                        height: 100,
                      ),
                      content: const Text(
                        '+20 1546546464\nتواصل معنا',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * .42,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  leading: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Image.asset(
                    AssetsData.logout,
                    width: 15,
                    height: 15,
                  ),
                  onTap: () {
                    final loginProvider = Provider.of<LoginProvider>(context,listen: false);
                    loginProvider.logout();

                    GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
                    log("TOOOOkEEEEEEEN${loginProvider.token.toString()}");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
