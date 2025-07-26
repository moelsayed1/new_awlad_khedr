import 'dart:convert';
import 'dart:math';

import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';

import '../../../drawer_slider/presentation/views/side_slider.dart';
import '../../../home/presentation/views/widgets/search_widget.dart';
import '../widgets/most_requested_app_bar.dart';

class MostRequestedPage extends StatefulWidget {
  const MostRequestedPage({super.key});

  @override
  State<MostRequestedPage> createState() => _MostRequestedPageState();
}

class _MostRequestedPageState extends State<MostRequestedPage> {
  TopRatedModel? topRatedItem;
  bool isListLoaded = false;

  final Map<String, int> _productQuantities =
      {}; // Key: product ID or unique identifier, Value: quantity
  final Map<Product, int> _cart = {}; // Add cart map

  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    GetTopRatedItems();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterProducts();
  }

  void _filterProducts() {
    if (topRatedItem == null || topRatedItem!.products.isEmpty) {
      _filteredProducts = [];
      return;
    }

    List<Product> tempProducts = topRatedItem!.products;

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      tempProducts = tempProducts.where((product) {
        return product.productName!.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredProducts = tempProducts;
    });
  }

  GetTopRatedItems() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_TOP_RATED_ITEMS);
    try {
      final response = await http
          .get(uriToSend, headers: {"Authorization": "Bearer $authToken"});
      if (response.statusCode == 200) {
        topRatedItem = TopRatedModel.fromJson(jsonDecode(response.body));
        if (topRatedItem != null && topRatedItem!.products.isNotEmpty) {
          for (var product in topRatedItem!.products) {
            _productQuantities[product.productName!] = 0;
          }
        }
        _filterProducts();
      } else {
        debugPrint(
            'Failed to load top rated items: ${response.statusCode.toString()}');
      }
    } catch (e) {
      debugPrint('Error fetching top rated items: ${e.toString()}');
    } finally {
      setState(() {
        isListLoaded = true;
      });
    }
  }

  void _onQuantityChanged(String productId, int newQuantity) {
    setState(() {
      _productQuantities[productId] = newQuantity;

      // Find the product with this productId
      final product = _filteredProducts.firstWhere(
        (p) => p.productName == productId,
        orElse: () => throw Exception('Product not found'),
      );

      if (newQuantity == 0) {
        // Remove from cart if quantity is 0
        _cart.remove(product);
      } else {
        // Update cart quantity
        _cart[product] = newQuantity;
      }
    });
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
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchWidget(controller: _searchController),
              const SizedBox(height: 8),
              const SizedBox(height: 15),
              isListLoaded
                  ? (topRatedItem != null && _filteredProducts.isNotEmpty
                      ? ListView.separated(
                          itemCount: min(_filteredProducts.length, 10),
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 15),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          reverse: false,
                          itemBuilder: (BuildContext context, int index) {
                            final product = _filteredProducts[index];
                            final quantity =
                                _productQuantities[product.productName!] ?? 0;
                            return CartProductCard(
                              item: {
                                'product': product,
                                'quantity': quantity,
                                'price': product.price is num
                                    ? (product.price as num).toDouble()
                                    : double.tryParse(
                                            product.price.toString()) ??
                                        0.0,
                                'total_price': (product.price is num
                                        ? (product.price as num).toDouble()
                                        : double.tryParse(
                                                product.price.toString()) ??
                                            0.0) *
                                    quantity,
                              },
                              isRemoving: false,
                              onIncrease: () async {
                                // Update UI immediately for better responsiveness
                                setState(() {
                                  _productQuantities[product.productName!] =
                                      quantity + 1;
                                  _cart[product] = quantity + 1;
                                });

                                // Make API call in background (no dialog for quantity changes)
                                final controller =
                                    Provider.of<CategoryController>(context,
                                        listen: false);
                                final success = await controller
                                    .addProductToCart(product, quantity + 1);

                                // If API call failed, revert the UI changes
                                if (!success && mounted) {
                                  setState(() {
                                    _productQuantities[product.productName!] =
                                        quantity;
                                    if (quantity == 0) {
                                      _cart.remove(product);
                                    } else {
                                      _cart[product] = quantity;
                                    }
                                  });

                                  // Show error dialog only for API failures
                                  showCustomDialog(
                                    context: context,
                                    icon: Icons.error,
                                    iconColor: Colors.red,
                                    message: 'حدث خطأ أثناء إضافة المنتج للسلة',
                                  );
                                }
                              },
                              onDecrease: () {
                                if (quantity > 0) {
                                  setState(() {
                                    final newQuantity = quantity - 1;
                                    _productQuantities[product.productName!] =
                                        newQuantity;
                                    if (newQuantity == 0) {
                                      _cart.remove(product);
                                    } else {
                                      _cart[product] = newQuantity;
                                    }
                                  });
                                }
                              },
                              onAddToCart: () async {
                                // Update UI immediately for better responsiveness
                                setState(() {
                                  _productQuantities[product.productName!] = 1;
                                  _cart[product] = 1;
                                });

                                // Show success dialog immediately
                                showCustomDialog(
                                  context: context,
                                  icon: Icons.check_circle,
                                  iconColor: const Color(0xffFC6E2A),
                                  message: 'تمت إضافة المنتج إلى السلة',
                                );

                                // Make API call in background
                                final controller =
                                    Provider.of<CategoryController>(context,
                                        listen: false);
                                final success = await controller
                                    .addProductToCart(product, 1);

                                // If API call failed, revert the UI changes
                                if (!success && mounted) {
                                  setState(() {
                                    _productQuantities[product.productName!] =
                                        0;
                                    _cart.remove(product);
                                  });

                                  // Show error dialog
                                  showCustomDialog(
                                    context: context,
                                    icon: Icons.error,
                                    iconColor: Colors.red,
                                    message: 'حدث خطأ أثناء إضافة المنتج للسلة',
                                  );
                                }
                              },
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                              'No products available for the current filter.')))
                  : const Center(child: CircularProgressIndicator()),
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
                        onClose: () => Navigator.pop(context),
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
