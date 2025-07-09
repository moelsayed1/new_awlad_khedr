import 'dart:convert';
import 'dart:math';

import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../drawer_slider/presentation/views/side_slider.dart';
import '../../../home/presentation/views/widgets/search_widget.dart';
import '../widgets/most_requested_app_bar.dart';
import '../widgets/product_item_card.dart';

class MostRequestedPage extends StatefulWidget {
  const MostRequestedPage({super.key});

  @override
  State<MostRequestedPage> createState() => _MostRequestedPageState();
}

class _MostRequestedPageState extends State<MostRequestedPage> {
  TopRatedModel? topRatedItem;
  bool isListLoaded = false;

  final Map<String, int> _productQuantities = {}; // Key: product ID or unique identifier, Value: quantity
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
      final response = await http.get(uriToSend, headers: {"Authorization" : "Bearer $authToken"});
      if (response.statusCode == 200) {
        topRatedItem = TopRatedModel.fromJson(jsonDecode(response.body));
        if (topRatedItem != null && topRatedItem!.products.isNotEmpty) {
          for (var product in topRatedItem!.products) {
            _productQuantities[product.productName!] = 0;
          }
        }
        _filterProducts();
      } else {
        debugPrint('Failed to load top rated items: ${response.statusCode.toString()}');
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
                  return ProductItemCard(
                    product: product,
                    quantity: _productQuantities[product.productName!] ?? 0,
                    onQuantityChanged: (newQuantity) {
                      _onQuantityChanged(product.productName!, newQuantity);
                    },
                    onAddToCart: () {
                      final currentQuantity = _productQuantities[product.productName!] ?? 0;
                      final newQuantity = currentQuantity + 1;
                      setState(() {
                        _productQuantities[product.productName!] = newQuantity;
                        _cart[product] = newQuantity;
                      });
                    },
                  );
                },
              )
                  : const Center(child: Text('No products available for the current filter.')))
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
      floatingActionButton: _cart.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Colors.orange,
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