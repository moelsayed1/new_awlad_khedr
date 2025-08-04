
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/custom_button.dart';
import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:awlad_khedr/features/auth/ticket_reserve/presentation/views/widgets/custom_add_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/app_router.dart';
import '../../../register/data/provider/register_provider.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _marketNameController = TextEditingController();
  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -130.h,
                right: -70.h,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                   SizedBox(height: 28.h),
                    InkWell(
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
                   SizedBox(height: 40.h),
                    const Text(
                      'أكمل التسجيل',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      endIndent: 10,
                      indent: 230,
                      color: Colors.black45,
                    ),
                   SizedBox(
                      height: 18.h,
                    ),
                    Text(
                      'رقم التليفون',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: '0102******',
                      inputType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      'عنوان الماركت',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomTextField(
                      controller: _addressController,
                      hintText: '',
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Text(
                      'اسم الماركت ',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    CustomTextField(
                      controller: _marketNameController,
                      hintText: '',
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Text(
                      'صورة الماركت',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    CustomAddFile(
                      onFilePicked: (file) {
                        registerProvider.saveFiles(marketImage: file);
                      },
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      'سجل التجاري',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    CustomAddFile(
                      onFilePicked: (file) {
                        registerProvider.saveFiles(commercialRegister: file);
                      },
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      'بطاقة ضربيبة',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    CustomAddFile(
                      onFilePicked: (file) {
                        registerProvider.saveFiles(taxCard: file);
                      },
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         Text(
                          'أوافُق أن البيانات التي تم إدخالها صحيحة',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: baseFont,
                              color: Colors.black),
                        ),
                        Checkbox(
                          value: isAgreed,
                          onChanged: (value) {
                            setState(() {
                              isAgreed = value!;
                            });
                          },
                        ),
                      ],
                    ),
                     SizedBox(
                      height: 24.h,
                    ),
                    Center(
                      child: CustomButton(
                          onTap: isAgreed
                              ? () async {
                                  await registerProvider.register({
                                    "mobile": _phoneController.text.trim(),
                                    "address_line_1":
                                        _addressController.text.trim(),
                                    "supplier_business_name":
                                        _marketNameController.text.trim(),
                                        
                                  });
                                  if (registerProvider.message != null) {
                                    GoRouter.of(context)
                                        .push(AppRouter.kSuccessScreen);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(registerProvider.message!)),
                                    );
                                  }
                                }
                              : null,
                          text: 'انتهاء',
                          width: 202,
                          height: 60,
                          color: isAgreed ? Colors.black : Colors.grey,
                          textColor: Colors.white,
                          fontSize: 30),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
