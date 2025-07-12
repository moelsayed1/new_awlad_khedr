import '../api_constants.dart';
import '../models/product_models.dart';
import '../models/auth_models.dart';
import 'api_service.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final ApiService _apiService = ApiService();

  // Get all products
  Future<ProductsResponse> getAllProducts() async {
    try {
      final response = await _apiService.get(ApiConstants.products);
      final responseData = _apiService.handleResponse(response);
      return ProductsResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get products failed: $e');
    }
  }

  // Get all banners
  Future<BannersResponse> getAllBanners() async {
    try {
      final response = await _apiService.get(ApiConstants.banners);
      final responseData = _apiService.handleResponse(response);
      return BannersResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get banners failed: $e');
    }
  }

  // Get total sold
  Future<ApiResponse<TotalSold>> getTotalSold() async {
    try {
      final response = await _apiService.get(ApiConstants.totalSold);
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, TotalSold.fromJson);
    } catch (e) {
      throw Exception('Get total sold failed: $e');
    }
  }

  // Get category products
  Future<CategoryProductsResponse> getCategoryProducts() async {
    try {
      final response = await _apiService.get(ApiConstants.categoryProducts);
      final responseData = _apiService.handleResponse(response);
      return CategoryProductsResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get category products failed: $e');
    }
  }

  // Get products by category ID
  Future<ProductsResponse> getProductsByCategory(int categoryId) async {
    try {
      final response = await _apiService.get('${ApiConstants.categoryProducts}/$categoryId');
      final responseData = _apiService.handleResponse(response);
      return ProductsResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get products by category failed: $e');
    }
  }

  // Search products
  Future<ProductsResponse> searchProducts(String query) async {
    try {
      final response = await _apiService.get('${ApiConstants.products}?search=$query');
      final responseData = _apiService.handleResponse(response);
      return ProductsResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Search products failed: $e');
    }
  }

  // Get product by ID
  Future<ApiResponse<Product>> getProductById(int productId) async {
    try {
      final response = await _apiService.get('${ApiConstants.products}/$productId');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, Product.fromJson);
    } catch (e) {
      throw Exception('Get product by ID failed: $e');
    }
  }

  // Get most popular products
  Future<ProductsResponse> getMostPopularProducts() async {
    try {
      final response = await _apiService.get('${ApiConstants.products}?popular=true');
      final responseData = _apiService.handleResponse(response);
      return ProductsResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get most popular products failed: $e');
    }
  }

  // Get featured products
  Future<ProductsResponse> getFeaturedProducts() async {
    try {
      final response = await _apiService.get('${ApiConstants.products}?featured=true');
      final responseData = _apiService.handleResponse(response);
      return ProductsResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get featured products failed: $e');
    }
  }
} 