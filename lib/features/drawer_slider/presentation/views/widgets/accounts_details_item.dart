import 'dart:ui' as ui;

import 'package:awlad_khedr/features/drawer_slider/presentation/views/widgets/popup_account_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../constant.dart';
import 'package:provider/provider.dart';
import '../../../../invoice/data/invoice_provider.dart';


class CustomAccountItem extends StatelessWidget {
  const CustomAccountItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingTransactions) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }
        final transactions = provider.transactions;
        if (transactions.isEmpty) {
          return const Center(child: Text('No transactions found.'));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(
                height: 28,
              ),
              itemBuilder: (BuildContext context, int index) {
                final tx = transactions[index];
                // Defensive null checks and fallback values
                final invoiceNumber = tx['invoice_number']?.toString() ?? '-';
                final amount = tx['final_total']?.toString() ?? '-';
                final due = tx['rest_of_dues']?.toString() ?? '-';
                final date = tx['create_date_cus']?.toString() ?? '-';
                final timeString = tx['create_date']?.toString() ?? '';
                String formattedTime = '-';
                if (timeString.isNotEmpty) {
                  try {
                    final dateTime = DateTime.parse(timeString);
                    formattedTime = DateFormat.jm().format(dateTime); // Format to time only (e.g., 5:08 PM)
                  } catch (e) {
                    // Handle parsing error if the date format is unexpected
                    formattedTime = '-';
                  }
                }
                // You can further parse/format date/time as needed
                return Container(
                  width: 326.w,
                  height: 150.h,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    'الدفع بكرة ',
                                    style: TextStyle(
                                        color: deepRed,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: baseFont),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'رقم الطلب $invoiceNumber#',
                                    style: const TextStyle(
                                      color: deepRed,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                   Text(
                                    'مطلوب دفعة ',
                                    style: TextStyle(
                                        color: kBrown,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: baseFont),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'EGP $due',
                                    style: const TextStyle(
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
                        const Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                          endIndent: 20,
                          indent: 20,
                        ),
                        Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                date,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.access_time,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              // You can extract and format time if available in tx
                              Text(
                                formattedTime,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                         const Spacer(),
                        OrderDetailsButton(transaction: tx),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}