import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/assets.dart';
import 'package:awlad_khedr/features/invoice/data/invoice_service.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

/// Helper function to extract userId from JWT token
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

/// Logic class for cart/order operations
class CartOrderLogic {
  /// Add a single product to cart
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
        Uri.parse(APIConstant.STORE_TO_CART),
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

  /// Add all products to cart
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

  /// Send order
  static Future<InvoiceServiceResult> sendOrder({
    required List<dynamic> products,
    required List<int> quantities,
    required double count,
  }) async {
    try {
      final result = await InvoiceService.placeOrder(
        products: products,
        quantities: quantities,
        total: count,
      );
      return InvoiceServiceResult(
        success: result.success,
        invoiceNo: result.invoiceNo,
        error: result.error,
      );
    } catch (e, stack) {
      log('Exception during order: $e\n$stack');
      return InvoiceServiceResult(
        success: false,
        error: 'حدث خطأ غير متوقع أثناء إرسال الطلب.',
      );
    }
  }
}

class InvoiceServiceResult {
  final bool success;
  final String? invoiceNo;
  final String? error;
  InvoiceServiceResult({required this.success, this.invoiceNo, this.error});
}

// ignore: must_be_immutable
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

  /// Main handler for order logic
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

    // Add products to cart
    final cartSuccess = await CartOrderLogic.addAllProductsToCart(
      token: token,
      userId: userId,
      products: widget.products,
      quantities: widget.quantities,
    );

    if (!cartSuccess) {
      await _hideLoadingDialog();
      setState(() => _isLoading = false);
      _showSnackBar(
        'حدث خطأ أثناء إضافة المنتجات للسلة. حاول مرة أخرى.',
        backgroundColor: darkOrange,
        textColor: Colors.black,
      );
      return;
    }

    // Send order
    final orderResult = await CartOrderLogic.sendOrder(
      products: widget.products,
      quantities: widget.quantities,
      count: widget.count,
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
          onPressed: () async {
            log('Order button pressed');
            if (widget.count < 3000) {
              _showSnackBar(
                'الحد الادني للاوردر 3000 جنيه لاستكمال الطلب',
                backgroundColor: darkOrange,
                textColor: Colors.black,
              );
              return;
            }
            log('products:  [34m${widget.products} [0m');
            log('quantities:  [34m${widget.quantities} [0m');
            setState(() => _isLoading = true);
            _showLoadingDialog(); // بدون await
            try {
              log('Calling InvoiceService.placeOrder...');
              final result = await InvoiceService.placeOrder(
                products: widget.products,
                quantities: widget.quantities,
                total: widget.count,
              );
              log('Order result: success=\x1B[32m${result.success}\x1B[0m, invoiceNo=${result.invoiceNo}, error=${result.error}');
              Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
              setState(() => _isLoading = false);
              if (result.success) {
                await _showOrderSuccessDialog(result.invoiceNo);
                widget.onOrderConfirmed();
              } else {
                _showSnackBar(result.error ?? 'حدث خطأ أثناء إرسال الطلب. حاول مرة أخرى.');
              }
            } catch (e, stack) {
              Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog if open
              setState(() => _isLoading = false);
              log('Exception during order: $e\n$stack');
              _showSnackBar('حدث خطأ غير متوقع أثناء إرسال الطلب.');
            }
          },
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
