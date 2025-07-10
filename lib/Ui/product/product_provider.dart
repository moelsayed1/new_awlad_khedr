import 'package:flutter/material.dart';
import '../../Api/api_manager.dart';
import '../../Api/models/product_models.dart' as api_models;

class ProductProvider extends ChangeNotifier {
  final ApiManager _apiManager = ApiManager();

  bool _isLoading = false;
  List<api_models.Product> _products = [];
  List<api_models.Category> _categories = [];
  List<api_models.Banner> _banners = [];
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<api_models.Product> get products => _products;
  List<api_models.Category> get categories => _categories;
  List<api_models.Banner> get banners => _banners;
  String? get errorMessage => _errorMessage;

  // Load all products
  Future<void> loadProducts() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.getAllProducts();

      if (response.success) {
        _products = (response.data as List<dynamic>? ?? [])
            .whereType<api_models.Product>()
            .toList();
        _setLoading(false);
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Failed to load products';
        _setLoading(false);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.getCategoryProducts();

      if (response.success) {
        _categories = (response.data as List<dynamic>? ?? [])
            .whereType<api_models.Category>()
            .toList();
        _setLoading(false);
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Failed to load categories';
        _setLoading(false);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
    }
  }

  // Load banners
  Future<void> loadBanners() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.getAllBanners();

      if (response.success) {
        _banners = (response.data as List<dynamic>? ?? [])
            .whereType<api_models.Banner>()
            .toList();
        _setLoading(false);
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Failed to load banners';
        _setLoading(false);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
    }
  }

  // Search products
  Future<List<api_models.Product>> searchProducts(String query) async {
    try {
      final response = await _apiManager.searchProducts(query);
      if (response.success) {
        return (response.data as List<dynamic>? ?? [])
            .whereType<api_models.Product>()
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get products by category
  Future<List<api_models.Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _apiManager.getProductsByCategory(categoryId);
      if (response.success) {
        return (response.data as List<dynamic>? ?? [])
            .whereType<api_models.Product>()
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get product by ID
  Future<api_models.Product?> getProductById(int productId) async {
    try {
      final response = await _apiManager.getProductById(productId);
      if (response.success) {
        return response.data is api_models.Product
            ? response.data as api_models.Product
            : null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get most popular products
  Future<List<api_models.Product>> getMostPopularProducts() async {
    try {
      final response = await _apiManager.getMostPopularProducts();
      if (response.success) {
        return (response.data as List<dynamic>? ?? [])
            .whereType<api_models.Product>()
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get featured products
  Future<List<api_models.Product>> getFeaturedProducts() async {
    try {
      final response = await _apiManager.getFeaturedProducts();
      if (response.success) {
        return (response.data as List<dynamic>? ?? [])
            .whereType<api_models.Product>()
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get total sold
  Future<api_models.TotalSold?> getTotalSold() async {
    try {
      final response = await _apiManager.getTotalSold();
      if (response.success) {
        return response.data is api_models.TotalSold
            ? response.data as api_models.TotalSold
            : null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Filter products by price range
  List<api_models.Product> filterProductsByPrice(
      double minPrice, double maxPrice) {
    return _products.where((product) {
      final price = double.tryParse(product.price?.toString() ?? '0') ?? 0;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  // Filter products by category
  // List<api_models.Product> filterProductsByCategory(int categoryId) {
  //   return _products.where((product) {
  //     return product.categoryId == categoryId;
  //   }).toList();
  // }

  // Sort products by price (low to high)
  List<api_models.Product> sortProductsByPriceAsc() {
    final sorted = List<api_models.Product>.from(_products);
    sorted.sort((a, b) {
      final priceA = double.tryParse(a.price?.toString() ?? '0') ?? 0;
      final priceB = double.tryParse(b.price?.toString() ?? '0') ?? 0;
      return priceA.compareTo(priceB);
    });
    return sorted;
  }

  // Sort products by price (high to low)
  List<api_models.Product> sortProductsByPriceDesc() {
    final sorted = List<api_models.Product>.from(_products);
    sorted.sort((a, b) {
      final priceA = double.tryParse(a.price?.toString() ?? '0') ?? 0;
      final priceB = double.tryParse(b.price?.toString() ?? '0') ?? 0;
      return priceB.compareTo(priceA);
    });
    return sorted;
  }

  // Sort products by name
  // List<api_models.Product> sortProductsByName() {
  //   final sorted = List<api_models.Product>.from(_products);
  //   sorted.sort((a, b) {
  //     return (a.name ?? '').compareTo(b.name ?? '');
  //   });
  //   return sorted;
  // }

  // // Get products with discount
  // List<api_models.Product> getProductsWithDiscount() {
  //   return _products.where((product) {
  //     return (product.discount ?? 0) > 0;
  //   }).toList();
  // }

  // Get products in stock
  // List<api_models.Product> getProductsInStock() {
  //   return _products.where((product) {
  //     return (product.stockQuantity ?? 0) > 0;
  //   }).toList();
  // }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _clearError() {
    _errorMessage = null;
  }
}
