import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentForm extends StatefulWidget {
  final VoidCallback? onPaymentSuccess;
  const PaymentForm({super.key, this.onPaymentSuccess});

  @override
  State<PaymentForm> createState() => PaymentFormState();
}

class PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إرسال الطلب بنجاح!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: baseFont,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
      if (widget.onPaymentSuccess != null) {
        widget.onPaymentSuccess!();
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputTextStyle = TextStyle(
      color: Colors.black87,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      fontFamily: baseFont,
    );
    
    final labelTextStyle = TextStyle(
      color: Colors.grey[700],
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      fontFamily: baseFont,
    );

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[50],
      labelStyle: labelTextStyle,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.red[400]!, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              style: inputTextStyle,
              decoration: inputDecoration.copyWith(
                labelText: 'الاسم',
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'يرجى إدخال الاسم' : null,
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _phoneController,
              style: inputTextStyle,
              decoration: inputDecoration.copyWith(
                labelText: 'رقم الهاتف',
                prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey[600]),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value == null || value.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _addressController,
              style: inputTextStyle,
              decoration: inputDecoration.copyWith(
                labelText: 'العنوان',
                prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey[600]),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'يرجى إدخال العنوان' : null,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkOrange,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: Text(
                'تأكيد الدفع',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
