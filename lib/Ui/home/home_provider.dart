import 'package:flutter/material.dart';
import '../../Api/api_manager.dart';
import '../../Api/models/product_models.dart' as api_models;

class HomeProvider extends ChangeNotifier {
  final ApiManager _apiManager = ApiManager();

  bool _isLoading = false;
  List<api_models.Product> _products = [];
  List<api_models.Banner> _banners = [];
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<api_models.Product> get products => _products;
  List<api_models.Banner> get banners => _banners;
  String? get errorMessage => _errorMessage;

  // Load home data
  Future<void> loadHomeData() async {
    _setLoading(true);
    _clearError();

    try {
      // Load products and banners in parallel
      final productsFuture = _apiManager.getAllProducts();
      final bannersFuture = _apiManager.getAllBanners();

      final results = await Future.wait([productsFuture, bannersFuture]);

      final productsResponse = results[0] as api_models.ProductsResponse;
      final bannersResponse = results[1] as api_models.BannersResponse;

      if (productsResponse.success) {
        _products = productsResponse.data ?? [];
      } else {
        _errorMessage = productsResponse.message;
      }

      if (bannersResponse.success) {
        _banners = bannersResponse.data ?? [];
      } else {
        _errorMessage = bannersResponse.message;
      }

      _setLoading(false);
      notifyListeners();
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
        return response.data ?? [];
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
        return response.data ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get most popular products
  Future<List<api_models.Product>> getMostPopularProducts() async {
    try {
      final response = await _apiManager.getMostPopularProducts();
      if (response.success) {
        return response.data ?? [];
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
        return response.data ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _clearError() {
    _errorMessage = null;
  }
}
