import 'package:awlad_khedr/Ui/widgets/cart_item_widget.dart';
import 'package:awlad_khedr/Ui/widgets/custom_button_cart.dart';
import 'package:awlad_khedr/Ui/widgets/custom_drawer.dart';
import 'package:awlad_khedr/new_core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant.dart';
import '../../new_core/main_layout.dart';
import '../../new_core/assets.dart';
import 'cart_provider.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Load cart data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            if (cartProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (cartProvider.cartItems.isEmpty) {
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
                      'لا توجد منتجات في السلة',
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

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0.r),
                    child: ListView.separated(
                      itemCount: cartProvider.cartItems.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15.h),
                      itemBuilder: (context, index) {
                        final cartItem = cartProvider.cartItems[index];
                        return CartItemWidget(
                          cartItem: cartItem,
                          onQuantityChanged: (newQuantity) {
                            cartProvider.updateCartItemQuantity(
                              cartItem.id!,
                              newQuantity,
                            );
                          },
                          onDelete: () {
                            cartProvider.deleteCartItem(cartItem.id!);
                          },
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
                            '${cartProvider.totalAmount.toStringAsFixed(2)} ج.م',
                            style: TextStyle(
                              color: kBrown,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              fontFamily: baseFont,
                            ),
                          ),
                          Text(
                            'المجموع',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              fontFamily: baseFont,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      CustomButtonCart(
                        onTap: () async {
                          if (cartProvider.totalAmount >= 3000) {
                            final success = await cartProvider.createOrder();
                            if (success) {
                              // Navigate to orders screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrdersScreen(),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('الحد الأدنى للطلب هو 3000 جنيه'),
                              ),
                            );
                          }
                        },
                        text: 'إتمام الطلب',
                        width: double.infinity,
                        height: 50.h,
                        color: cartProvider.totalAmount >= 3000
                            ? Colors.black
                            : Colors.grey,
                        textColor: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
