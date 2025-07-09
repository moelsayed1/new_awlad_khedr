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
  String _currentSearchQuery = ''; // Add a field to store the current search query

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

  Future<void> fetchAllProducts() async {
    isListLoaded = false; // Set to false before fetching
    safeNotifyListeners();
    try {
      final products = await _repository.fetchAllProducts();
      topRatedItem = TopRatedModel(products: products);
      _updateProductQuantities(products);
      applySearchFilter(_currentSearchQuery); // Re-apply search filter after new products are fetched
    } catch (e) {
      log('Error fetching all products: $e');
      topRatedItem = TopRatedModel(products: []); // Clear products on error
    } finally {
      isListLoaded = true;
      safeNotifyListeners();
    }
  }

  Future<void> fetchProductsByCategory() async {
    if (selectedCategory == null || selectedCategory.isEmpty) {
      log('No category selected');
      return;
    }

    isListLoaded = false; // Set to false before fetching
    safeNotifyListeners();
    
    try {
      final products = await _repository.fetchProductsByCategory(selectedCategory);
      if (products != null && products.isNotEmpty) {
        topRatedItem = TopRatedModel(products: products);
        _updateProductQuantities(products);
        filteredProducts = products; // Set filtered products directly first
        applySearchFilter(_currentSearchQuery); // Then apply any search filter
      } else {
        topRatedItem = TopRatedModel(products: []);
        filteredProducts = [];
      }
    } catch (e) {
      log('Error fetching category products: $e');
      topRatedItem = TopRatedModel(products: []); // Clear products on error
      filteredProducts = [];
    } finally {
      isListLoaded = true;
      safeNotifyListeners();
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

  void applySearchFilter(String query) {
    _currentSearchQuery = query; // Update the stored search query
    List<Product> productsToFilter = topRatedItem?.products ?? [];
    if (query.isNotEmpty) {
      filteredProducts = productsToFilter.where((product) {
        return (product.productName?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    } else {
      filteredProducts = productsToFilter;
    }
    safeNotifyListeners();
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