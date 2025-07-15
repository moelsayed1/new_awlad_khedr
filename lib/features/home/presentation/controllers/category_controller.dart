import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'dart:developer';


class CategoryController extends ChangeNotifier {
  final CategoryRepository _repository;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  CategoryController(this._repository) {
    // Initialize data immediately when controller is created
    initializeData();
  }

  // State
  TopRatedModel? topRatedItem;
  bool isListLoaded = false;
  List<String> categories = ['الكل'];
  String selectedCategory = 'الكل';
  final Map<String, int> productQuantities = {}; // Key will be product ID or unique identifier
  final Map<Product, int> cart = {};
  List<Product> filteredProducts = [];
  String _currentSearchQuery = '';

  // Pagination state
  int currentPage = 1;
  bool hasMoreProducts = true;
  bool isLoadingProducts = false;
  final List<Product> _allLoadedProducts = [];

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
      // Fetch categories first
      await fetchCategories();
      
      // Then fetch products based on selected category
      if (selectedCategory == 'الكل') {
        await fetchAllProducts();
      } else {
        await fetchProductsByCategory();
      }

      // Initialize filtered products
      filteredProducts = topRatedItem?.products ?? [];
      
      // Mark data as loaded
      isListLoaded = true;
      safeNotifyListeners();

    } catch (e) {
      log('Error initializing data: $e');
      isListLoaded = true;
      topRatedItem = TopRatedModel(products: []); // Initialize with empty list on error
      filteredProducts = [];
      safeNotifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    categories = await _repository.fetchCategories();
    safeNotifyListeners();
  }

  Future<void> fetchAllProducts({bool reset = true}) async {
    if (isLoadingProducts) return;
    isLoadingProducts = true;
    if (reset) {
      isListLoaded = false;
      currentPage = 1;
      hasMoreProducts = true;
      _allLoadedProducts.clear();
      safeNotifyListeners();
    }
    try {
      final products = await _repository.fetchAllProducts(page: currentPage, pageSize: 10, search: _currentSearchQuery.isNotEmpty ? _currentSearchQuery : null);
      if (reset) {
        _allLoadedProducts.clear();
      }
      _allLoadedProducts.addAll(products);
      topRatedItem = TopRatedModel(products: _allLoadedProducts);
      _updateProductQuantities(_allLoadedProducts);
      applySearchFilter(_currentSearchQuery, notify: false);
      if (products.length < 10) {
        hasMoreProducts = false;
      }
    } catch (e) {
      log('Error fetching all products: $e');
      if (reset) {
        topRatedItem = TopRatedModel(products: []);
        _allLoadedProducts.clear();
      }
      hasMoreProducts = false;
    } finally {
      isListLoaded = true;
      isLoadingProducts = false;
      safeNotifyListeners();
    }
  }

  Future<void> fetchProductsByCategory({bool reset = true}) async {
    if (selectedCategory == null || selectedCategory.isEmpty) {
      log('No category selected');
      return;
    }
    if (isLoadingProducts) return;
    isLoadingProducts = true;
    if (reset) {
      isListLoaded = false;
      currentPage = 1;
      hasMoreProducts = true;
      _allLoadedProducts.clear();
      safeNotifyListeners();
    }
    try {
      final products = await _repository.fetchProductsByCategory(selectedCategory, page: currentPage, pageSize: 10, search: _currentSearchQuery.isNotEmpty ? _currentSearchQuery : null);
      if (reset) {
        _allLoadedProducts.clear();
      }
      _allLoadedProducts.addAll(products);
      topRatedItem = TopRatedModel(products: _allLoadedProducts);
      _updateProductQuantities(_allLoadedProducts);
      filteredProducts = _allLoadedProducts;
      applySearchFilter(_currentSearchQuery, notify: false);
      if (products.length < 10) {
        hasMoreProducts = false;
      }
    } catch (e) {
      log('Error fetching category products: $e');
      if (reset) {
        topRatedItem = TopRatedModel(products: []);
        _allLoadedProducts.clear();
      }
      hasMoreProducts = false;
      filteredProducts = [];
    } finally {
      isListLoaded = true;
      isLoadingProducts = false;
      safeNotifyListeners();
    }
  }

  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts || isLoadingProducts) return;
    currentPage++;
    if (selectedCategory == 'الكل') {
      await fetchAllProducts(reset: false);
    } else {
      await fetchProductsByCategory(reset: false);
    }
  }

  void _updateProductQuantities(List<Product> products) {
    // Preserve existing quantities for products that are still present
    final Map<String, int> newProductQuantities = {};
    for (var product in products) {
      final String key = product.productId?.toString() ?? product.productName ?? UniqueKey().toString();
      newProductQuantities[key] = productQuantities[key] ?? 0; // Keep old quantity if exists, else 0
    }
    productQuantities.clear();
    productQuantities.addAll(newProductQuantities);
  }

  void applySearchFilter(String query, {bool notify = true}) {
    _currentSearchQuery = query;
    List<Product> productsToFilter = _allLoadedProducts;
    if (query.isNotEmpty) {
      filteredProducts = productsToFilter.where((product) {
        return (product.productName?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    } else {
      filteredProducts = productsToFilter;
    }
    if (notify) safeNotifyListeners();
  }

  // This internal method is now redundant as applySearchFilter is public and stores the query
  // void _applySearchFilter() {
  //   filteredProducts = topRatedItem?.products ?? [];
  // }

  void onCategorySelected(String category) {
    selectedCategory = category;
    // When category changes, clear search query and re-fetch products
    _currentSearchQuery = ''; // Clear search when category changes
    safeNotifyListeners(); // Notify listeners to update UI (e.g., search bar text)
    // The fetch logic is handled in _CategoriesView's CategoryFilterBar onTap
  }

  void onQuantityChanged(String productKey, int newQuantity) {
    productQuantities[productKey] = newQuantity;
    safeNotifyListeners();
  }

  void addToCart(Product product) {
    // Use product ID as the key for the cart if available, otherwise product itself
    // Or, better, store a map of product ID to quantity for cart
    // For simplicity, keeping product as key here
    cart[product] = (cart[product] ?? 0) + 1;
    safeNotifyListeners();
  }

  void clearCart() {
    cart.clear();
    // Set all product quantities to zero
    productQuantities.updateAll((key, value) => 0);
    safeNotifyListeners();
  }
}