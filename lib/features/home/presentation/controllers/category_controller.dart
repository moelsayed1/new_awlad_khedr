import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as top_rated;
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    initializeData();
  }

  top_rated.TopRatedModel? topRatedItem;
  bool isListLoaded = false;
  List<String> categories = ['الكل'];
  String selectedCategory = 'الكل';
  final Map<String, int> productQuantities = {};
  final Map<top_rated.Product, int> cart = {};
  List<top_rated.Product> filteredProducts = [];
  String _currentSearchQuery = '';

  int currentPage = 1;
  bool hasMoreProducts = true;
  bool isLoadingProducts = false;
  final List<top_rated.Product> _allLoadedProducts = [];

  // جديد: خريطة لتخزين جميع المنتجات للبحث الفعال (مثل سلة التسوق)
  final Map<int, top_rated.Product> _allProductsById = {};
  bool _isAllProductsMapLoaded = false;

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

  Future<void> initializeData() async {
    isListLoaded = false;
    safeNotifyListeners();

    try {
      await fetchCategories();
      // التأكد من تحميل جميع المنتجات في خريطة البحث أولاً
      await _loadAllProductsForLookup();
      
      if (selectedCategory == 'الكل') {
        await fetchAllProducts();
      } else {
        await fetchProductsByCategory();
      }

      filteredProducts = topRatedItem?.products ?? [];
      
      isListLoaded = true;
      safeNotifyListeners();

    } catch (e) {
      log('Error initializing data: $e');
      isListLoaded = true;
      topRatedItem = top_rated.TopRatedModel(products: []);
      filteredProducts = [];
      safeNotifyListeners();
    }
  }

  // دالة جديدة لتحميل جميع المنتجات في خريطة البحث
  Future<void> _loadAllProductsForLookup() async {
    if (_isAllProductsMapLoaded && _allProductsById.isNotEmpty) {
      log('All products lookup map already loaded.');
      return;
    }
    log('Loading all products for lookup map...');
    try {
      final allProductsList = await _repository.fetchAllProducts(page: 1, pageSize: 10000); 
      _allProductsById.clear();
      for (var p in allProductsList) {
        if (p.productId != null) {
          _allProductsById[p.productId!] = p;
        }
      }
      _isAllProductsMapLoaded = true;
      log('Successfully loaded ${_allProductsById.length} products into lookup map.');
    } catch (e) {
      log('Error loading all products for lookup map: $e');
      _isAllProductsMapLoaded = false;
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
      topRatedItem = top_rated.TopRatedModel(products: _allLoadedProducts);
      _updateProductQuantities(_allLoadedProducts);
      applySearchFilter(_currentSearchQuery, notify: false);
      if (products.length < 10) {
        hasMoreProducts = false;
      }
    } catch (e) {
      log('Error fetching all products: $e');
      if (reset) {
        topRatedItem = top_rated.TopRatedModel(products: []);
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
      topRatedItem = top_rated.TopRatedModel(products: _allLoadedProducts);
      _updateProductQuantities(_allLoadedProducts);
      filteredProducts = _allLoadedProducts;
      applySearchFilter(_currentSearchQuery, notify: false);
      if (products.length < 10) {
        hasMoreProducts = false;
      }
    } catch (e) {
      log('Error fetching category products: $e');
      if (reset) {
        topRatedItem = top_rated.TopRatedModel(products: []);
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

  void _updateProductQuantities(List<top_rated.Product> products) {
    final Map<String, int> newProductQuantities = {};
    for (var product in products) {
      final String key = product.productId?.toString() ?? product.productName ?? UniqueKey().toString();
      newProductQuantities[key] = productQuantities[key] ?? 0;
    }
    productQuantities.clear();
    productQuantities.addAll(newProductQuantities);
  }

  void applySearchFilter(String query, {bool notify = true}) {
    _currentSearchQuery = query;
    List<top_rated.Product> productsToFilter = _allLoadedProducts;
    if (query.isNotEmpty) {
      filteredProducts = productsToFilter.where((product) {
        return (product.productName?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    } else {
      filteredProducts = productsToFilter;
    }
    if (notify) safeNotifyListeners();
  }

  void onCategorySelected(String category) {
    selectedCategory = category;
    _currentSearchQuery = ''; 
    safeNotifyListeners(); 
  }

  void onQuantityChanged(String productKey, int newQuantity) {
    productQuantities[productKey] = newQuantity;
    safeNotifyListeners();
  }

  void addToCart(top_rated.Product product) {
    cart[product] = (cart[product] ?? 0) + 1;
    safeNotifyListeners();
  }

  void clearCart() {
    cart.clear();
    productQuantities.updateAll((key, value) => 0);
    safeNotifyListeners();
  }

  static const String _cartBaseUrl = 'https://erp.khedrsons.com/api/cart';

  Future<bool> addProductToCart(top_rated.Product product, int quantity) async {
    log('CategoryController.addProductToCart called for productId: ${product.productId}, quantity: ${quantity}');
    final success = await _repository.addProductToCart(
      productId: product.productId ?? 0,
      quantity: quantity,
      price: product.price,
    );
    return success;
  }

  List<Map<String, dynamic>> fetchedCartItems = [];

  Future<void> fetchCartFromApi() async {
    log('CategoryController.fetchCartFromApi called');
    // التأكد من تحميل جميع المنتجات في خريطة البحث قبل معالجة سلة التسوق
    if (!_isAllProductsMapLoaded) {
      await _loadAllProductsForLookup();
    }
    
    final cartList = await _repository.fetchCartFromApi();

    cart.clear();
    fetchedCartItems.clear();

    // استخدام الخريطة الشاملة _allProductsById للبحث
    final Map<int, top_rated.Product> allProductsMap = _allProductsById;

    for (var item in cartList) {
      final productId = item['product_id'];
      final product = allProductsMap[productId]; 
      
      final quantity = int.tryParse(item['product_quantity'].toString()) ?? 1;
      final price = double.tryParse(item['price'].toString()) ?? 0.0;
      
      if (product != null) {
        cart[product] = quantity;
        fetchedCartItems.add({
          'product': product,
          'quantity': quantity,
          'price': price,
          'total_price': price * quantity,
        });
      } else {
        log('Skipping cart item with product_id $productId because product not found in _allProductsById. This means the product was not loaded into the comprehensive map. Double-check product fetching logic or product IDs.');
      }
    }
    safeNotifyListeners();
  }

  double get fetchedCartTotal {
    double total = 0;
    for (var item in fetchedCartItems) {
      total += (item['total_price'] as double? ?? 0.0);
    }
    return total;
  }
}