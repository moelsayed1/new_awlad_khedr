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
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:provider/provider.dart';

class CartViewPage extends StatefulWidget {
  // No need to pass products/quantities; always use controller
  const CartViewPage({super.key, required List<top_rated.Product> products, required List<int> quantities});

  @override
  State<CartViewPage> createState() => _CartViewPageState();
}

class _CartViewPageState extends State<CartViewPage> {
  late CategoryController controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<CategoryController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchCartFromApi();
      setState(() {
        _loading = false;
      });
    });
  }

  void _onQuantityChanged(top_rated.Product product, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        controller.cart[product] = newQuantity;
      } else {
        controller.cart.remove(product);
      }
    });
  }

  double get _total {
    double total = 0;
    controller.cart.forEach((product, qty) {
      final price = double.tryParse(product.price ?? '0') ?? 0;
      total += price * qty;
    });
    return total;
  }

  List<top_rated.Product> get selectedProducts => controller.cart.keys.toList();
  List<int> get selectedQuantities => controller.cart.values.toList();

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<CategoryController>(context); // Listen for changes
    final cartItems = controller.fetchedCartItems.where((item) => item['product'] != null).toList();
    return MainLayout(
      selectedIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
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
                textDirection: TextDirection.rtl,
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
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0.r),
                      child: (cartItems.isEmpty)
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
                                    'لا توجد منتجات صالحة في السلة',
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
                              itemCount: cartItems.length,
                              separatorBuilder: (context, index) => SizedBox(height: 15.h),
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                final product = item['product'];
                                final quantity = item['quantity'] as int;
                                final price = item['price'] as double;
                                final totalPrice = item['total_price'] as double;

                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Product image on the left
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: Container(
                                          color: Colors.grey[100],
                                          child: (product.imageUrl != null && product.imageUrl != '')
                                              ? Image.network(
                                                  product.imageUrl,
                                                  width: 60.w,
                                                  height: 60.w,
                                                  fit: BoxFit.cover,
                                                )
                                              : Icon(Icons.image, size: 60.w, color: Colors.grey[300]),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      // Product info and details (right to the image)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              product.productName ?? '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.sp,
                                                fontFamily: baseFont,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              'شرنك = $quantity × ${price.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.black87,
                                                fontFamily: baseFont,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              'سعر EGP ${price.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black,
                                                fontFamily: baseFont,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              'سعر الاجمالي EGP ${totalPrice.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.brown[700],
                                                fontFamily: baseFont,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      // Quantity control column (vertical +, number, -)
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Plus button
                                          GestureDetector(
                                            onTap: () {
                                              // TODO: Implement increment logic
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: Color(0xffFC6E2A), // darkOrange
                                              size: 28.sp,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          // Quantity display
                                          Container(
                                            width: 40.w,
                                            height: 40.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey[300]!),
                                              borderRadius: BorderRadius.circular(12.r),
                                              color: Colors.white,
                                            ),
                                            child: Text(
                                              quantity.toString(),
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.black87,
                                                fontFamily: baseFont,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          // Minus button
                                          GestureDetector(
                                            onTap: () {
                                              // TODO: Implement decrement logic
                                            },
                                            child: Container(
                                              width: 28.w,
                                              height: 4.h,
                                              decoration: BoxDecoration(
                                                color: Color(0xffC29500), // kBrown
                                                borderRadius: BorderRadius.circular(2.r),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
                              '\t${controller.fetchedCartTotal.toInt()} ج.م ',
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
                        // Order Now Button
                        CustomButtonCart(
                          count: controller.fetchedCartTotal,
                          onOrderConfirmed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Order placed!')),
                            );
                          },
                          products: cartItems.map((item) => item['product']).toList(),
                          quantities: cartItems.map((item) => item['quantity'] as int).toList(),
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
