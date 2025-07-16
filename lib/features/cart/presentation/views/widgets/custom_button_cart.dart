import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/assets.dart';
import 'package:awlad_khedr/features/invoice/data/invoice_service.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String? extractUserIdFromToken(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload);
    return payloadMap['sub']?.toString();
  } catch (e) {
    return null;
  }
}

class CartOrderLogic {
  static Future<bool> addSingleProductToCart({
    required String? token,
    required String? userId,
    required dynamic product,
    required int quantity,
  }) async {
    try {
      final price = product.price.toString();
      final totalPrice = (double.tryParse(price)! * quantity).toString();
      final response = await http.post(
        Uri.parse(APIConstant.STORE_ORDER),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "user_id": userId,
          "product_id": product.productId.toString(),
          "product_quantity": quantity.toString(),
          "price": price,
          "total_price": totalPrice,
        }),
      );
      log('Add to cart response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('Error adding product to cart: $e');
      return false;
    }
  }

  static Future<bool> addAllProductsToCart({
    required String? token,
    required String? userId,
    required List<dynamic> products,
    required List<int> quantities,
  }) async {
    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      final quantity = quantities[i];
      final success = await addSingleProductToCart(
        token: token,
        userId: userId,
        product: product,
        quantity: quantity,
      );
      if (!success) {
        return false;
      }
    }
    return true;
  }
}

// InvoiceServiceResult class should be in invoice_service.dart
class InvoiceServiceResult {
  final bool success;
  final String? invoiceNo;
  final String? error;
  InvoiceServiceResult({required this.success, this.invoiceNo, this.error});
}

class InvoiceService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<InvoiceServiceResult> placeSaleOrder({
    required String token,
    required String userId,
    required List<dynamic> products,
    required List<int> quantities,
    required double total,
  }) async {
    try {
      final String? baseUrl = APIConstant.BASE_URL;
      if (baseUrl == null) {
        return InvoiceServiceResult(success: false, error: 'Base URL not configured.');
      }
      final Uri uri = Uri.parse(APIConstant.STORE_ORDER);

      final List<Map<String, dynamic>> items = [];
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        final quantity = quantities[i];
        final price = product.price?.toString() ?? '0.0';
        items.add({
          "product_id": product.productId?.toString() ?? '',
          "product_quantity": quantity.toString(),
          "price": price,
        });
      }

      final payload = {
        "user_id": userId,
        "total_price": total.toString(),
        "items": items,
        "mobile": true,
      };
      log('Order payload: ${json.encode(payload)}');
      log('Order userId: $userId, total: $total, items: $items');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(payload),
      );

      log('Place sale order response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        final String? invoiceNo = responseBody['invoice_no']?.toString() ?? responseBody['message']?.toString();
        return InvoiceServiceResult(success: true, invoiceNo: invoiceNo);
      } else {
        final errorBody = json.decode(response.body);
        final String errorMessage = errorBody['message']?.toString() ?? 'Failed to place order.';
        return InvoiceServiceResult(success: false, error: 'Error ${response.statusCode}: $errorMessage');
      }
    } catch (e, stack) {
      log('Exception placing sale order: $e\n$stack');
      return InvoiceServiceResult(success: false, error: 'حدث خطأ غير متوقع أثناء إرسال الطلب: $e');
    }
  }
}

class CustomButtonCart extends StatefulWidget {
  final List<dynamic> products;
  final List<int> quantities;
  final double count;
  final VoidCallback onOrderConfirmed;

  const CustomButtonCart({
    super.key,
    required this.count,
    required this.onOrderConfirmed,
    required this.products,
    required this.quantities,
  });

  @override
  State<CustomButtonCart> createState() => _CustomButtonCartState();
}

class _CustomButtonCartState extends State<CustomButtonCart> {
  bool _isLoading = false;

  Future<void> _showLoadingDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("جاري إرسال الطلب..."),
            ],
          ),
        );
      },
    );
  }

  Future<void> _hideLoadingDialog() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showOrderSuccessDialog(String? invoiceNo) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Image.asset(
          AssetsData.bag,
          width: 100,
          height: 100,
        ),
        content: Text(
          textAlign: TextAlign.center,
          'تم تأكيد طلبك بنجاح${invoiceNo != null ? "\nرقم الفاتورة: $invoiceNo" : ""}',
          style: TextStyle(
              fontFamily: baseFont,
              fontSize: 25.sp,
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _showSnackBar(String message, {Color? backgroundColor, Color? textColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? darkOrange,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: baseFont,
          ),
        ),
      ),
    );
  }

  Future<void> _handleOrder() async {
    if (widget.count < 3000) {
      _showSnackBar(
        'الحد الادني للاوردر 3000 جنيه لاستكمال الطلب',
        backgroundColor: darkOrange,
        textColor: Colors.black,
      );
      return;
    }

    setState(() => _isLoading = true);
    _showLoadingDialog();

    final token = await InvoiceService.getToken();
    final userId = extractUserIdFromToken(token ?? '');

    if (token == null || userId == null) {
      await _hideLoadingDialog();
      setState(() => _isLoading = false);
      _showSnackBar('حدث خطأ في تسجيل الدخول. يرجى إعادة المحاولة.');
      return;
    }

    final orderResult = await InvoiceService.placeSaleOrder(
      token: token,
      userId: userId,
      products: widget.products,
      quantities: widget.quantities,
      total: widget.count,
    );

    await _hideLoadingDialog();
    setState(() => _isLoading = false);

    if (orderResult.success) {
      await _showOrderSuccessDialog(orderResult.invoiceNo);
      widget.onOrderConfirmed();
    } else {
      _showSnackBar(orderResult.error ?? 'حدث خطأ أثناء إرسال الطلب. حاول مرة أخرى.');
    }
  }

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
          onPressed: _isLoading ? null : _handleOrder,
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'اطلب الان',
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


