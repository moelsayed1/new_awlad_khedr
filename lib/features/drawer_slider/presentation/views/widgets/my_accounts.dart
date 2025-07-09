import 'package:awlad_khedr/features/drawer_slider/presentation/views/widgets/accounts_details_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../constant.dart';
import '../../../../../core/assets.dart';

class MyAccounts extends StatelessWidget {
  const MyAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Row(
            children: [
              Image.asset(
                AssetsData.back,
                color: Colors.black,
              ),
              const Text(
                'للخلف',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: baseFont,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'حساباتي',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*.45,
                    height: 90,
                    decoration: const BoxDecoration(
                        color: darkOrange,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'رصيد الاجل المتبقي',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: baseFont),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Image.asset(
                                AssetsData.account,
                                color: Colors.black,
                                width: 15,
                                height: 15,
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Text(
                            'EGP 3000',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              // fontFamily: baseFont
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width*.45,
                    height: 90,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'اجمالي المستحقات',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: baseFont),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Image.asset(
                                AssetsData.account,
                                color: Colors.white,
                                width: 15,
                                height: 15,
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Text(
                            'EGP 5000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              // fontFamily: baseFont
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                width: 326,
                height: 112,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: deepRed,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            Icon(Icons.sentiment_satisfied_alt),
                            Text(
                              'الدفع القادم بعد يوم ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: baseFont,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'مطلوب دفعة \nEGP500',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                // fontFamily: baseFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                        Divider(
                        thickness: .5,
                        color: Colors.white,
                        endIndent: 20,
                        indent: 20,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(
                              width: 8,
                            ),
                            Text('اكتوبر - الاربعاء -22'),
                            Spacer(),
                            Icon(Icons.access_time),
                            SizedBox(
                              width: 8,
                            ),
                            Text('11:00 - 12:00 م'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
          const CustomAccountItem(),

            ],
          ),
        ),
      ),
    );
  }
}
