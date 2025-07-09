import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/cart/presentation/views/widgets/cart_item.dart';
import 'package:awlad_khedr/features/cart/presentation/views/widgets/custom_button_cart.dart';
import 'package:awlad_khedr/features/order/presentation/views/orders_view.dart';
import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as top_rated;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart';

class CartViewPage extends StatefulWidget {
  final List<top_rated.Product> products;
  final List<int> quantities;

  const CartViewPage({
    super.key,
    required this.products,
    required this.quantities,
  });

  @override
  State<CartViewPage> createState() => _CartViewPageState();
}

class _CartViewPageState extends State<CartViewPage> {
  late List<int> _quantities;
  double _total = 0;

  @override
  void initState() {
    super.initState();
    _quantities = List<int>.from(widget.quantities);
    _calculateTotal();
  }

  void _onQuantityChanged(int index, int newQuantity) {
    setState(() {
      _quantities[index] = newQuantity;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _total = 0;
    for (int i = 0; i < widget.products.length; i++) {
      final price = double.tryParse(widget.products[i].price ?? '0') ?? 0;
      _total += price * _quantities[i];
    }
  }

  List<top_rated.Product> get selectedProducts {
    List<top_rated.Product> selected = [];
    for (int i = 0; i < widget.products.length; i++) {
      if (_quantities[i] > 0) {
        selected.add(widget.products[i]);
      }
    }
    return selected;
  }

  List<int> get selectedQuantities {
    return [
      for (int i = 0; i < widget.products.length; i++)
        if (_quantities[i] > 0) _quantities[i]
    ];
  }

  List<top_rated.Product> get selectedProductsForPayment {
    List<top_rated.Product> selected = [];
    for (int i = 0; i < widget.products.length; i++) {
      if (_quantities[i] > 0) {
        final p = widget.products[i];
        selected.add(p);
      }
    }
    return selected;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Light background to match image
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'الاوردر',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont,
                ),
                textDirection: TextDirection.rtl, // Right-to-left for Arabic
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Builder(
              builder: (context) => IconButton(
                icon: Image.asset(
                  AssetsData.drawerIcon,
                  height: 45,
                  width: 45,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          centerTitle: true,
          titleSpacing: 0,
        ),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0.r),
                child: (widget.products.isEmpty || _quantities.every((q) => q == 0))
                  ? Center(
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
                            'لا توجد منتجات في السلة',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                              fontFamily: baseFont,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: widget.products.length,
                      separatorBuilder: (context, index) => SizedBox(height: 15.h),
                      itemBuilder: (context, index) {
                        final product = widget.products[index];
                        final quantity = _quantities[index];
                        return CartItem(
                          product: product, // Pass single product
                          quantity: quantity, // Pass single quantity
                          index: index, // Pass the index
                          onQuantityChanged: _onQuantityChanged,
                        );
                      },
                    ),
              ),
            ),
            // Bottom Total Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'الحد الادني الاوردر 3000 جنيه لاستكمال الطلب',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '	${_total.toInt()} ج.م ',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: baseFont,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        'الاجمالي',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  CustomButtonCart(
                    count: _total,
                    onOrderConfirmed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrdersViewPage(),
                        ),
                      );
                    },
                    products: selectedProducts,
                    quantities: selectedQuantities,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
