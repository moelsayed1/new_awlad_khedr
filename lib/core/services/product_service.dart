import 'dart:developer';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/core/network/api_service.dart';
import 'package:awlad_khedr/constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Make sure http is imported for jsonDecode

class ProductService {
  final ApiService _apiService;
  Map<int, Product> _allProductsCache = {};

  static final ProductService _instance = ProductService._internal(ApiService());
  factory ProductService() => _instance;
  ProductService._internal(this._apiService);

  Future<void> fetchAndCacheAllProducts() async {
    try {
      final response = await _apiService.get(
        Uri.parse(APIConstant.GET_ALL_PRODUCTS).replace(
          queryParameters: {'page': '1', 'page_size': '10000'},
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Product> products = [];

        if (jsonResponse is Map<String, dynamic>) {
          if (jsonResponse.containsKey('data')) {
            var data = jsonResponse['data'];
            if (data is Map<String, dynamic> && data.containsKey('products') && data['products'] is List) {
              products = (data['products'] as List)
                  .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
                  .toList();
            } else if (data is List) {
              products = (data as List)
                  .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
                  .toList();
            }
          } else if (jsonResponse.containsKey('products') && jsonResponse['products'] is List) {
            products = (jsonResponse['products'] as List)
                .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
                .toList();
          }
        } else if (jsonResponse is List) {
          products = jsonResponse
              .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
              .toList();
        }

        _allProductsCache.clear();
        for (var p in products) {
          if (p.productId != null) {
            _allProductsCache[p.productId!] = p;
          }
        }
      }
    } catch (e) {
      log('Error fetching and caching products: $e');
    }
  }

  Product? getProductById(int productId) {
    return _allProductsCache[productId];
  }

  List<Product> getAllProducts() {
    return _allProductsCache.values.toList();
  }

  void cacheProducts(List<Product> products) {
    _allProductsCache.clear();
    for (var p in products) {
      if (p.productId != null) {
        _allProductsCache[p.productId!] = p;
      }
    }
  }
} 