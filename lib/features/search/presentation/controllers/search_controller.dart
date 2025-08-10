import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ProductSearchController extends ChangeNotifier {
  final CategoryRepository _repository;
  final String initialQuery;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  ProductSearchController(this._repository, {required this.initialQuery}) {
    // Initialize data immediately when controller is created
    initializeData();
    loadSearchHistory();
  }

  void initializeWithCategory(String? category) {
    if (category != null && category.isNotEmpty) {
      selectedCategory = category;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _applyCategoryFilter(category);
        safeNotifyListeners();
      });
    }
  }

  // State
  bool isListLoaded = false;
  List<Product> allProducts = [];
  List<Product> searchResults = [];
  List<String> categories = [];
  String searchQuery = '';
  String selectedCategory = '';
  List<String> searchHistory = [];
  final Map<String, int> productQuantities = {};
  final Map<Product, int> cart = {};
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoading = false;
  List<Product> pagedProducts = [];
  String lastCategory = '';
  String lastSearch = '';
  Product? selectedProduct;

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
      // Do not load categories or products by default
      searchQuery = '';
      selectedCategory = '';
      isListLoaded = true;
      safeNotifyListeners();
    } catch (e) {
      log('Error initializing search data: $e');
      isListLoaded = true;
      pagedProducts = [];
      categories = [];
      safeNotifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      categories = await _repository.fetchCategories();
      log('Fetched categories: $categories');
    } catch (e) {
      log('Error fetching categories: $e');
      categories = [];
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      allProducts = await _repository.fetchAllProducts();
      _updateProductQuantities(allProducts);
    } catch (e) {
      log('Error fetching all products: $e');
      allProducts = [];
    }
  }

  void _updateProductQuantities(List<Product> products) {
    final Map<String, int> newProductQuantities = {};
    for (var product in products) {
      final String key = product.productId?.toString() ?? product.productName ?? UniqueKey().toString();
      // Always start with 0 quantity for new products
      newProductQuantities[key] = 0;
    }
    productQuantities.clear();
    productQuantities.addAll(newProductQuantities);
  }

  /// Fetches products for the current search query and category, and updates pagedProducts.
  Future<void> fetchInitialProducts() async {
    isLoading = true;
    currentPage = 1;
    pagedProducts.clear();
    hasMore = true;
    lastCategory = selectedCategory;
    lastSearch = searchQuery;

    if (selectedProduct != null) {
      pagedProducts = [selectedProduct!];
      hasMore = false;
      isLoading = false;
      safeNotifyListeners();
      return;
    }

    try {
      log('Fetching initial products - Category: "$selectedCategory", Search: "$searchQuery"');
      List<Product> firstPage;
      if (searchQuery.isNotEmpty) {
        // If there is a search query, always use the search endpoint
        firstPage = await _repository.searchProducts(
          category: selectedCategory.isNotEmpty && selectedCategory != 'الكل' ? selectedCategory : null,
          productName: searchQuery,
          page: currentPage,
          pageSize: pageSize,
        );
      } else if (selectedCategory.isNotEmpty && selectedCategory != 'الكل') {
        // If only category is selected, use category endpoint
        firstPage = await _repository.fetchProductsByCategory(
          selectedCategory,
          page: currentPage,
          pageSize: pageSize,
          search: null,
        );
      } else {
        // Otherwise, fetch all products
        firstPage = await _repository.fetchAllProducts(
          page: currentPage,
          pageSize: pageSize,
          search: null,
        );
      }
      pagedProducts.addAll(firstPage);
      hasMore = firstPage.length == pageSize;
      log('Initial products loaded: ${firstPage.length} products, hasMore: $hasMore');
    } catch (e) {
      log('Error fetching initial products: $e');
      pagedProducts = [];
      hasMore = false;
    }

    isLoading = false;
    safeNotifyListeners();
  }

  Future<void> fetchNextPage() async {
    if (!hasMore || isLoading || selectedProduct != null) return;

    isLoading = true;
    currentPage++;

    try {
      log('Fetching next page - Category: "$selectedCategory", Search: "$searchQuery", Page: $currentPage');
      List<Product> nextPage;
      if (searchQuery.isNotEmpty) {
        nextPage = await _repository.searchProducts(
          category: selectedCategory.isNotEmpty && selectedCategory != 'الكل' ? selectedCategory : null,
          productName: searchQuery,
          page: currentPage,
          pageSize: pageSize,
        );
      } else if (selectedCategory.isNotEmpty && selectedCategory != 'الكل') {
        nextPage = await _repository.fetchProductsByCategory(
          selectedCategory,
          page: currentPage,
          pageSize: pageSize,
          search: null,
        );
      } else {
        nextPage = await _repository.fetchAllProducts(
          page: currentPage,
          pageSize: pageSize,
          search: null,
        );
      }

      pagedProducts.addAll(nextPage);
      hasMore = nextPage.length == pageSize;
      log('Next page loaded: ${nextPage.length} products, hasMore: $hasMore');
    } catch (e) {
      log('Error fetching next page: $e');
      hasMore = false;
    }

    isLoading = false;
    safeNotifyListeners();
  }

  /// This method performs the search and updates the pagedProducts list,
  /// so that the search result screen displays what the user searched for.
  Future<void> searchProducts(String query) async {
    searchQuery = query.trim();
    selectedProduct = null;

    // Save to search history if not empty
    if (searchQuery.isNotEmpty) {
      await saveSearchHistory(searchQuery);
    }

    log('Searching products with query: "$searchQuery" in category: "$selectedCategory"');
    await fetchInitialProducts();
  }

  /// Smart search: if query matches a category, select it; otherwise, search as product
  Future<void> searchWithSmartLogic(String query) async {
    searchQuery = query;
    pagedProducts = [];
    safeNotifyListeners();

    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      // Clear results if query is empty
      pagedProducts = [];
      safeNotifyListeners();
      return;
    }

    // Only search if query is at least 2 characters
    if (trimmedQuery.length < 2) {
      // Optionally show a message to the user
      pagedProducts = [];
      safeNotifyListeners();
      return;
    }

    final categoryList = await _repository.fetchCategories();
    if (categoryList.contains(trimmedQuery)) {
      await selectCategory(trimmedQuery);
    } else {
      await searchProducts(trimmedQuery);
    }
  }

  void clearResults() {
    pagedProducts = [];
    safeNotifyListeners();
  }

  void onQuantityChanged(String productKey, int newQuantity) {
    productQuantities[productKey] = newQuantity;
    safeNotifyListeners();
  }

  void clearCart() {
    cart.clear();
    productQuantities.updateAll((key, value) => 0);
    safeNotifyListeners();
  }

  Future<void> _applyCategoryFilter(String category) async {
    log('Applying category filter for: "$category"');
    selectedCategory = category;
    searchQuery = '';
    selectedProduct = null;
    await fetchInitialProducts();
  }

  Future<void> selectCategory(String category) async {
    selectedCategory = category;
    searchQuery = '';
    selectedProduct = null;
    log('Selected category: "$category"');
    await fetchInitialProducts();
  }

  void selectProduct(Product product) {
    selectedProduct = product;
    log('Selected product: ${product.productName}');
    safeNotifyListeners();
  }

  void clearCategoryFilter() {
    selectedCategory = '';
    searchQuery = '';
    selectedProduct = null;
    log('Cleared category filter');
    fetchInitialProducts();
  }

  String getFilterState() {
    return 'Search: "$searchQuery", Category: "$selectedCategory", Results: ${pagedProducts.length}, HasMore: $hasMore';
  }

  // Search History Methods
  Future<void> loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('search_history') ?? [];
      searchHistory = history;
      safeNotifyListeners();
    } catch (e) {
      log('Error loading search history: $e');
    }
  }

  Future<void> saveSearchHistory(String query) async {
    try {
      if (query.trim().isEmpty) return;

      searchHistory.remove(query.trim());
      searchHistory.insert(0, query.trim());
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.take(10).toList();
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', searchHistory);
      safeNotifyListeners();
    } catch (e) {
      log('Error saving search history: $e');
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      searchHistory.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('search_history');
      safeNotifyListeners();
    } catch (e) {
      log('Error clearing search history: $e');
    }
  }
}