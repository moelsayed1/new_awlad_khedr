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
    final products = controller.cart.keys.toList();
    final quantities = controller.cart.values.toList();
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
                      child: (products.isEmpty || quantities.every((q) => q == 0))
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
                              itemCount: products.length,
                              separatorBuilder: (context, index) => SizedBox(height: 15.h),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final quantity = quantities[index];
                                return CartItem(
                                  product: product,
                                  quantity: quantity,
                                  index: index,
                                  onQuantityChanged: (idx, newQuantity) => _onQuantityChanged(product, newQuantity),
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
                              '\t${_total.toInt()} ج.م ',
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
