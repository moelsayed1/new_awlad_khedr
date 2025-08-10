import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/order/data/model/order_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:awlad_khedr/core/network/api_service.dart';

String formatPrice(dynamic price) {
  if (price == null) return '0';
  final num? value = num.tryParse(price.toString());
  if (value == null) return price.toString();
  if (value % 1 == 0) {
    return value.toInt().toString();
  }
  return value.toString();
}

class CustomButtonReceipt extends StatelessWidget {
  final Order order;
  const CustomButtonReceipt({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 32.h,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(mainColor),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ReceiptOrderDetails(order: order);
              },
            );
          },
          child: const Text(
            'فاتورة الطلب',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: baseFont),
          ),
        ),
      ),
    );
  }
}

class ReceiptOrderDetails extends StatefulWidget {
  final Order order;
  const ReceiptOrderDetails({super.key, required this.order});

  @override
  State<ReceiptOrderDetails> createState() => _ReceiptOrderDetailsState();
}

class _ReceiptOrderDetailsState extends State<ReceiptOrderDetails> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _invoiceData;

  @override
  void initState() {
    super.initState();
    _fetchInvoice();
  }

  Future<void> _fetchInvoice() async {
    setState(() { _loading = true; _error = null; });
    try {
      final apiService = ApiService();
      await apiService.init();
      final response = await apiService.getOrderInvoice(widget.order.invoiceId.toString());
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _invoiceData = data['order-invoice'] ?? {};
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'فشل في جلب الفاتورة';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ أثناء جلب الفاتورة';
        _loading = false;
      });
    }
  }

  Widget _buildOrderItem(String name, String price, {Color? priceColor, FontWeight? nameWeight, Color? nameColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: priceColor ?? Colors.black,
              fontSize: 16,
            ),
            textDirection: TextDirection.rtl,
          ),
          Text(
            name,
            style: TextStyle(
              fontWeight: nameWeight ?? FontWeight.bold,
              color: nameColor ?? Colors.black,
              fontSize: 16,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: _loading
                ? const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                  ),
                ),
              )
                : _error != null
                    ? SizedBox(height: 120, child: Center(child: Text(_error!, style: const TextStyle(color: Colors.red))))
                    : _invoiceData == null
                        ? const SizedBox(height: 120, child: Center(child: Text('لا توجد بيانات فاتورة')))
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              // Title and underline
                              const Text(
                                'فاتورة الطلب',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  height: 3,
                                  width: 40,
                                  color: darkOrange,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Invoice details
                              _buildOrderItem(
                                'اجمالي الفاتورة',
                                '${formatPrice(_invoiceData?['final_total'])} ج.م',
                                nameWeight: FontWeight.bold,
                                nameColor: Colors.black,
                                priceColor: Colors.black,
                              ),
                              _buildOrderItem(
                                'خصم',
                                '${formatPrice(_invoiceData?['discount'])} ج.م',
                                nameWeight: FontWeight.bold,
                                nameColor: Colors.black,
                                priceColor: Colors.black54,
                              ),
                              _buildOrderItem(
                                'مجموع السعر',
                                '${formatPrice(_invoiceData?['total_price'] ?? _invoiceData?['final_total'])} ج.م',
                                nameWeight: FontWeight.bold,
                                nameColor: Colors.black,
                                priceColor: Colors.black87,
                              ),
                              _buildOrderItem(
                                'طريقة الدفع',
                                _invoiceData?['payment_method']?.toString() ?? 'دفع الاجل',
                                nameWeight: FontWeight.bold,
                                nameColor: Colors.black,
                                priceColor: Colors.blue,
                              ),
                            ],
                          ),
          ),
          // Close button at top left
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 24, color: Colors.black),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
