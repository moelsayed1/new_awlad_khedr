// DEPRECATED: This controller is no longer used. Cart and product logic are now handled by the global CategoryController.
// This file can be deleted after verifying all references are removed.
import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'dart:developer';

class BannerProductsController extends ChangeNotifier {
  final CategoryRepository _repository;
  final int? categoryId;
  final int? brandId;
  final String? categoryName;
  final String? brandName;
  final dynamic selectedProduct;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  BannerProductsController(
    this._repository, {
    this.categoryId,
    this.brandId,
    this.categoryName,
    this.brandName,
    this.selectedProduct,
  }) {
    // Initialize data immediately when controller is created
    initializeData();
  }

  // State
  TopRatedModel? topRatedItem;
  bool isListLoaded = false;
  bool isLoadingMore = false;
  bool hasMoreProducts = true;
  final Map<String, int> productQuantities = {};
  final Map<Product, int> cart = {};
  List<Product> allProducts = [];
  List<Product> displayedProducts = [];
  List<Product> filteredProducts = [];
  String _currentSearchQuery = '';

  // Pagination variables
  int currentPage = 0;
  static const int productsPerPage = 10;

  // Getters
  double get cartTotal {
    double total = 0;
    cart.forEach((product, qty) {
      final price = product.price;
      double priceValue = 0;
      if (price is num) {
        priceValue = (price as num?)?.toDouble() ?? 0;
      } else if (price is String) {
        priceValue = double.tryParse(price) ?? 0;
      }
      total += priceValue * qty;
    });
    return total;
  }

  // Methods
  Future<void> initializeData() async {
    isListLoaded = false;
    safeNotifyListeners();

    try {
      // If a selectedProduct is provided, show only that product
      if (selectedProduct != null) {
        final product = selectedProduct as Product;
        topRatedItem = TopRatedModel(products: [product]);
        allProducts = [product];
        _updateProductQuantities([product]);
        filteredProducts = [product];
        resetPagination();
        loadNextPage();
        isListLoaded = true;
        safeNotifyListeners();
        return;
      }
      // Fetch products based on banner data
      await fetchBannerProducts();

      // Initialize filtered products
      filteredProducts = topRatedItem?.products ?? [];

      // Mark data as loaded
      isListLoaded = true;
      safeNotifyListeners();
    } catch (e) {
      log('Error initializing data: $e');
      isListLoaded = true;
      topRatedItem = TopRatedModel(products: []);
      filteredProducts = [];
      safeNotifyListeners();
    }
  }

  Future<void> fetchBannerProducts() async {
    isListLoaded = false;
    safeNotifyListeners();

    try {
      List<Product> products = [];

      // If brand ID is provided, fetch products by brand
      if (brandId != null) {
        products = await _repository.fetchProductsByBrand(brandId!);
      }
      // If category name is provided, fetch products by category
      else if (categoryName != null) {
        products = await _repository.fetchProductsByCategory(categoryName!);
      }
      // Fallback to all products
      else {
        products = await _repository.fetchAllProducts();
      }

      topRatedItem = TopRatedModel(products: products);
      allProducts = products;
      _updateProductQuantities(products);
      applySearchFilter(_currentSearchQuery);

      // Reset pagination and load first page
      resetPagination();
      loadNextPage();
    } catch (e) {
      log('Error fetching banner products: $e');
      topRatedItem = TopRatedModel(products: []);
      allProducts = [];
      displayedProducts = [];
      filteredProducts = [];
    } finally {
      isListLoaded = true;
      safeNotifyListeners();
    }
  }

  void resetPagination() {
    currentPage = 0;
    displayedProducts.clear();
    hasMoreProducts = true;
    isLoadingMore = false;
  }

  void loadNextPage() {
    if (isLoadingMore || !hasMoreProducts) return;

    isLoadingMore = true;
    safeNotifyListeners();

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final startIndex = currentPage * productsPerPage;
      final endIndex = startIndex + productsPerPage;

      if (startIndex < filteredProducts.length) {
        final newProducts = filteredProducts.sublist(
            startIndex,
            endIndex > filteredProducts.length
                ? filteredProducts.length
                : endIndex);

        displayedProducts.addAll(newProducts);
        currentPage++;
        isLoadingMore = false;
        hasMoreProducts = endIndex < filteredProducts.length;
      } else {
        isLoadingMore = false;
        hasMoreProducts = false;
      }
      safeNotifyListeners();
    });
  }

  void _updateProductQuantities(List<Product> products) {
    final Map<String, int> newProductQuantities = {};
    for (var product in products) {
      final String key = product.productId?.toString() ??
          product.productName ??
          UniqueKey().toString();
      newProductQuantities[key] = productQuantities[key] ?? 0;
    }
    productQuantities.clear();
    productQuantities.addAll(newProductQuantities);
  }

  void applySearchFilter(String query) {
    _currentSearchQuery = query;
    List<Product> productsToFilter = allProducts;
    if (query.isNotEmpty) {
      filteredProducts = productsToFilter.where((product) {
        return (product.productName
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false);
      }).toList();
    } else {
      filteredProducts = productsToFilter;
    }

    // Reset pagination when search changes
    resetPagination();
    loadNextPage();
  }

  void onQuantityChanged(String productKey, int newQuantity) {
    productQuantities[productKey] = newQuantity;
    safeNotifyListeners();
  }

  void addToCart(Product product) {
    cart[product] = (cart[product] ?? 0) + 1;
    safeNotifyListeners();
  }

  void clearCart() {
    cart.clear();
    productQuantities.updateAll((key, value) => 0);
    safeNotifyListeners();
  }

  Future<bool> addProductToCart(Product product, int quantity) async {
    // يمكنك تخصيص المنطق حسب الحاجة
    final success = await _repository.addProductToCart(
      productId: product.productId ?? 0,
      quantity: quantity,
      price: product.price,
    );
    return success;
  }
}
