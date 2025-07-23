import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awlad_khedr/features/most_requested/presentation/widgets/most_requested_app_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final Map<Product, int> _cart = {};
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    // You might want to get the initial quantity from a provider
    // if the product was already in the cart.
  }

  void showCustomDialog({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(icon, color: iconColor, size: 48),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: baseFont,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFC6E2A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'حسناً',
                      style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double cartTotal = 0;
    _cart.forEach((product, qty) {
      final price = product.price;
      double priceValue = 0;
      if (price is num) {
        priceValue = (price as num?)?.toDouble() ?? 0;
      } else if (price is String) {
        priceValue = double.tryParse(price) ?? 0;
      }
      cartTotal += priceValue * qty;
    });

    return Scaffold(
      appBar: const MostRequestedAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CartProductCard(
                item: {
                  'product': widget.product,
                  'quantity': _quantity,
                  'price': widget.product.price ?? 0.0,
                  'total_price': (_quantity * (widget.product.price ?? 0.0)),
                },
                isRemoving: false,
                onIncrease: () {
                  setState(() {
                    _quantity++;
                    _cart[widget.product] = _quantity;
                  });
                },
                onDecrease: () {
                  if (_quantity > 0) {
                    setState(() {
                      _quantity--;
                      if (_quantity == 0) {
                        _cart.remove(widget.product);
                      } else {
                        _cart[widget.product] = _quantity;
                      }
                    });
                  }
                },
                onAddToCart: () async {
                  final controller =
                      Provider.of<CategoryController>(context, listen: false);
                  final newQuantity = (_quantity == 0) ? 1 : _quantity;

                  setState(() {
                    _quantity = newQuantity;
                    _cart[widget.product] = newQuantity;
                  });

                  final success =
                      await controller.addProductToCart(widget.product, newQuantity);

                  if (success) {
                    showCustomDialog(
                      context: context,
                      icon: Icons.check_circle,
                      iconColor: const Color(0xffFC6E2A),
                      message: 'تمت إضافة المنتج إلى السلة',
                    );
                  } else {
                    if (mounted) {
                      setState(() {
                        _quantity = 0;
                        _cart.remove(widget.product);
                      });
                      showCustomDialog(
                        context: context,
                        icon: Icons.error,
                        iconColor: Colors.red,
                        message: 'حدث خطأ أثناء إضافة المنتج للسلة',
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 20.h),
              // Add more product details here if needed
            ],
          ),
        ),
      ),
      floatingActionButton: _cart.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xffFC6E2A),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.33,
                    minChildSize: 0.33,
                    maxChildSize: 0.33,
                    expand: false,
                    builder: (context, scrollController) {
                      return CartSheet(
                        cart: _cart,
                        total: cartTotal,
                        onClose: () {
                          if (mounted) Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              },
              label: Text(
                'السلة (${_cart.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont,
                ),
              ),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            )
          : null,
    );
  }
} 