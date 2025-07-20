import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/order/presentation/views/widgets/custom_rating.dart';
import 'package:awlad_khedr/features/order/presentation/views/widgets/popup_order_reciept.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../order/data/model/order_model.dart';
import '../../../order/presentation/controllers/order_provider.dart';

import '../../../../core/assets.dart';
import 'dart:convert';
import 'package:awlad_khedr/core/network/api_service.dart';

class OrdersViewPage extends StatefulWidget {
  final String? highlightInvoiceNo;
  const OrdersViewPage({super.key, this.highlightInvoiceNo});

  @override
  State<OrdersViewPage> createState() => _OrdersViewPageState();
}

class _OrdersViewPageState extends State<OrdersViewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false)
          .fetchOrders(highlightInvoiceNo: widget.highlightInvoiceNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrdersAppBar(),
      body: const OrdersList(),
    );
  }
}

class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrdersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: InkWell(
            onTap: () {
              GoRouter.of(context).pop();
            },
            child: Row(
              children: [
                Image.asset(
                  AssetsData.back,
                  color: Colors.black,
                  width: 24.w,
                  height: 24.h,
                ),
                Text(
                  'للخلف',
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 100.w,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'الطلبات',
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont),
            ),
          )
        ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).orders;
    final highlightedInvoiceNo = Provider.of<OrderProvider>(context).highlightedInvoiceNo;

    if (orders.isEmpty) {
      return const OrdersEmptyWidget();
    }

    return ListView.builder(
      itemCount: orders.length,
      padding: EdgeInsets.all(16.w),
      itemBuilder: (context, index) {
        final isHighlighted = orders[index].id == highlightedInvoiceNo;
        return Container(
          decoration: isHighlighted
              ? BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 3),
                  borderRadius: BorderRadius.circular(15.r),
                )
              : null,
          child: OrderCard(order: orders[index], index: index, totalOrders: orders.length),
        );
      },
    );
  }
}

class OrdersEmptyWidget extends StatelessWidget {
  const OrdersEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            '... لا توجد طلبات بعد',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontFamily: baseFont,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final int index;
  final int totalOrders;
  const OrderCard({super.key, required this.order, required this.index, required this.totalOrders});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrderCardHeader(date: order.date),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                children: [
                  OrderNumberRow(orderId: order.id),
                  SizedBox(height: 8.h),
                  OrderCardMainRow(order: order, index: index, totalOrders: totalOrders),
                  SizedBox(height: 16.h),
                  OrderInvoiceButton(order: order),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCardHeader extends StatelessWidget {
  final DateTime date;
  const OrderCardHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
            '${arabicWeekday(date.weekday)} . ${date.day} ${arabicMonth(date.month)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: baseFont,
                    ),
                  ),
                ],
              ),
    );
  }
}

class OrderNumberRow extends StatelessWidget {
  final dynamic orderId;
  const OrderNumberRow({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
          'طلب رقم #$orderId',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                          fontFamily: baseFont,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
    );
  }
}

class OrderCardMainRow extends StatelessWidget {
  final Order order;
  final int index;
  final int totalOrders;
  const OrderCardMainRow({super.key, required this.order, required this.index, required this.totalOrders});

  @override
  Widget build(BuildContext context) {
    return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Payment
                      Expanded(
                        flex: 2,
          child: OrderCardPaymentColumn(order: order),
        ),
        SizedBox(width: 8.w),
        // Right: Status, car, rating
        Expanded(
          flex: 3,
          child: OrderCardStatusColumn(index: index, totalOrders: totalOrders),
        ),
      ],
    );
  }
}

class OrderCardPaymentColumn extends StatelessWidget {
  final Order order;
  const OrderCardPaymentColumn({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مطلوب دفعة',
                              style: TextStyle(
            color: Color(0xFFB88A3B),
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                                fontFamily: baseFont,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                              '${order.total} ج.م',
                              style: TextStyle(
                                color: Color(0xFFB88A3B),
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                                fontFamily: baseFont,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
        OrderProductsButton(order: order),
      ],
    );
  }
}

class OrderProductsButton extends StatelessWidget {
  final Order order;
  const OrderProductsButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
            return OrderProductsDialog(order: order);
                                  },
                                );
                              },
                              child: Container(
                                width: 120.w,
                                height: 36.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Text(
                                    'عرض المنتجات',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontFamily: baseFont,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
    );
  }
}

class OrderCardStatusColumn extends StatelessWidget {
  final int index;
  final int totalOrders;
  const OrderCardStatusColumn({super.key, required this.index, required this.totalOrders});

  @override
  Widget build(BuildContext context) {
    return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'عربة ${totalOrders - index}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontFamily: baseFont,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'جاري الاستلام',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15.sp,
                                    fontFamily: baseFont,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Image.asset(
                                  AssetsData.cycle,
                                  width: 24.w,
                                  height: 24.h,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h), 
                          ],
    );
  }
}

class OrderInvoiceButton extends StatelessWidget {
  final Order order;
  const OrderInvoiceButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2D6),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ReceiptOrderDetails(order: order);
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          elevation: 0,
                        ),
                        child: Text(
                          'فاتورة الطلب',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
    );
  }
}

class OrderProductsDialog extends StatefulWidget {
  final Order order;
  const OrderProductsDialog({required this.order, super.key});

  @override
  State<OrderProductsDialog> createState() => _OrderProductsDialogState();
}

class _OrderProductsDialogState extends State<OrderProductsDialog> {
  bool _loading = true;
  List<dynamic> _products = [];
  String? _error;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchOrderProducts();
  }

  Future<void> _fetchOrderProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final apiService = ApiService();
      await apiService.init();
      final response = await apiService.getOrderDetails(widget.order.invoiceId.toString());
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final orderData = data['order'];
        final sellLines = orderData['sell_lines'] as List<dynamic>?;
        double total = 0.0;
        if (sellLines != null) {
          for (var item in sellLines) {
            final quantity = double.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
            final price = double.tryParse(item['unit_price']?.toString() ?? '0') ?? 0;
            total += quantity * price;
          }
        }
        setState(() {
          _products = sellLines ?? [];
          _totalPrice = total;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'فشل في جلب المنتجات';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ أثناء جلب المنتجات';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: SizedBox(
          width: 340,
          child: _loading
              ? const OrderProductsLoading()
              : _error != null
                  ? OrderProductsError(error: _error!)
                  : _products.isEmpty
                      ? const OrderProductsEmpty()
                      : OrderProductsList(
                          products: _products,
                          orderId: widget.order.id,
                          totalPrice: _totalPrice,
                        ),
        ),
      ),
    );
  }
}

class OrderProductsLoading extends StatelessWidget {
  const OrderProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class OrderProductsError extends StatelessWidget {
  final String error;
  const OrderProductsError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(error, textDirection: TextDirection.rtl),
    );
  }
}

class OrderProductsEmpty extends StatelessWidget {
  const OrderProductsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('لا توجد منتجات في هذا الطلب', textDirection: TextDirection.rtl),
    );
  }
}

class OrderProductsList extends StatelessWidget {
  final List<dynamic> products;
  final dynamic orderId;
  final double totalPrice;
  const OrderProductsList({
    super.key,
    required this.products,
    required this.orderId,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Close icon row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close icon at the top left
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, size: 24, color: Colors.black),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                  'منتجات الطلب\nرقم #$orderId',
                  style: TextStyle(
                    fontFamily: baseFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ],
        ),
        // Orange underline
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 2, bottom: 10),
            height: 3,
            width: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A00),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Header Row
        const SizedBox(height: 16),
        const OrderProductsHeaderRow(),
        const SizedBox(height: 6),
        // Products List
        ...products.map((item) => OrderProductRow(item: item)).toList(),
        const SizedBox(height: 8),
        // إجمالي السعر
        OrderProductsTotalRow(totalPrice: totalPrice),
      ],
    );
  }
}

class OrderProductsHeaderRow extends StatelessWidget {
  const OrderProductsHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                'الكمية',
                style: TextStyle(
                  fontFamily: baseFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              'اسم المنتج',
              style: TextStyle(
                fontFamily: baseFont,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'السعر',
              style: TextStyle(
                fontFamily: baseFont,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderProductRow extends StatelessWidget {
  final dynamic item;
  const OrderProductRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item['product'] ?? {};
    final name = product['name']?.toString() ?? '';
    final quantity = item['quantity']?.toString() ?? '';
    final price = item['unit_price']?.toString() ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Quantity
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                quantity,
                style: TextStyle(
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          // Name
          Expanded(
            flex: 5,
            child: Text(
              name,
              style: TextStyle(
                fontFamily: baseFont,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          // Price
          Expanded(
            flex: 3,
            child: Text(
              '$price ج.م',
              style: TextStyle(
                fontFamily: baseFont,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderProductsTotalRow extends StatelessWidget {
  final double totalPrice;
  const OrderProductsTotalRow({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '${totalPrice.toStringAsFixed(2)} ج.م',
            style: TextStyle(
              fontFamily: baseFont,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
            textDirection: TextDirection.rtl,
          ),
      Spacer(),
          Text(
            'إجمالي السعر',
            style: TextStyle(
              fontFamily: baseFont,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
       
        ],
      ),
    );
          
        
  }
  }

  // Helper functions for Arabic date
String arabicWeekday(int weekday) {
    switch (weekday) {
      case DateTime.saturday:
        return 'السبت';
      case DateTime.sunday:
        return 'الأحد';
      case DateTime.monday:
        return 'الاثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      default:
        return '';
    }
  }

String arabicMonth(int month) {
    const months = [
      '', // 0
      'يناير',
      'فبراير',
      'مارس',
      'ابريل',
      'مايو',
      'يونيو',
      'يوليو',
      'اغسطس',
      'سبتمبر',
      'اكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    if (month >= 1 && month <= 12) {
      return months[month];
    }
    return '';
}
