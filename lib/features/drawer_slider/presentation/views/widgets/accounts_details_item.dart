import 'package:awlad_khedr/features/drawer_slider/presentation/views/widgets/popup_account_details.dart';
import 'package:flutter/material.dart';
import '../../../../../constant.dart';


class CustomAccountItem extends StatefulWidget {
  const CustomAccountItem({super.key});

  @override
  State<CustomAccountItem> createState() => _CustomAccountItemState();
}

class _CustomAccountItemState extends State<CustomAccountItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 28,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 326,
              height: 164,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'الدفع بكرة ',
                                style: TextStyle(
                                    color: deepRed,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: baseFont),
                              ),
                              Text(
                                'رقم الطلب 525963#',
                                style: TextStyle(
                                  color: deepRed,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                'مطلوب دفعة ',
                                style: TextStyle(
                                    color: kBrown,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: baseFont),
                              ),
                              Text(
                                'EGP500',
                                style: TextStyle(
                                  color: kBrown,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                      endIndent: 20,
                      indent: 20,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'اكتوبر - الاربعاء -22',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(),
                          Icon(
                            Icons.access_time,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            '11:00 - 12:00 م',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    OrderDetailsButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

