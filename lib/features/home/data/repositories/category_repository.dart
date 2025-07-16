import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/main.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:awlad_khedr/core/network/api_service.dart';
import 'package:awlad_khedr/core/services/product_service.dart';


class CategoryRepository {
  final ApiService _apiService;
  final ProductService _productService;

  CategoryRepository(this._apiService, this._productService);

  Future<bool> _validateToken() async {
    if (authToken.isEmpty) {
      return false;
    }
    try {
      final response = await http.get(
        Uri.parse(APIConstant.GET_ALL_PRODUCTS),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      log('Error validating token: $e');
      return false;
    }
  }

  Future<void> _clearInvalidToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    authToken = '';
  }

  Future<List<String>> fetchCategories() async {
    try {
      if (!await _validateToken()) {
        await _clearInvalidToken();
        throw Exception('Invalid or expired token');
      }

      final response = await http.get(
        Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Cache-Control": "no-cache",
          "Pragma": "no-cache",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<String> fetchedCategories = [];

        if (jsonResponse['categories'] != null && jsonResponse['categories'] is List) {
          for (var categoryJson in jsonResponse['categories']) {
            if (categoryJson['category_name'] != null && (categoryJson['category_name'] as String).isNotEmpty) {
              fetchedCategories.add(categoryJson['category_name'] as String);
            }
          }
        }
        return ['الكل', ...fetchedCategories.toSet()];
      } else if (response.statusCode == 401) {
        await _clearInvalidToken();
        throw Exception('Unauthorized access');
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching categories: $e');
      return ['الكل'];
    }
  }

  Future<List<Product>> fetchAllProducts({int page = 1, int pageSize = 10, String? search}) async {
    try {
      if (!await _validateToken()) {
        await _clearInvalidToken();
        throw Exception('Invalid or expired token');
      }

      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
        log('Searching all products with query: "${search.trim()}"');
      }

      final uri = Uri.parse(APIConstant.GET_ALL_PRODUCTS).replace(
        queryParameters: queryParams,
      );

      log('Fetching all products from: $uri');

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Cache-Control": "no-cache",
          "Pragma": "no-cache",
        },
      );

      log('All products response status:  [32m [1m${response.statusCode} [0m');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Product> products = [];

        if (jsonResponse is Map<String, dynamic>) {
          if (jsonResponse['data'] is Map<String, dynamic> &&
              jsonResponse['data']['products'] is List) {
            products = (jsonResponse['data']['products'] as List)
                .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
                .toList();
          } else if (jsonResponse['products'] is List) {
            products = (jsonResponse['products'] as List)
                .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
                .toList();
          } else if (jsonResponse['data'] is List) {
            products = (jsonResponse['data'] as List)
                .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
                .toList();
          }
        } else if (jsonResponse is List) {
          products = jsonResponse
              .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
              .toList();
        }

        _productService.cacheProducts(products);
        log('Parsed  [32m${products.length} [0m products from all products endpoint (page $page, pageSize $pageSize) and cached.');
        return products;
      } else if (response.statusCode == 401) {
        await _clearInvalidToken();
        throw Exception('Unauthorized access');
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching all products: $e');
      return [];
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category, {int page = 1, int pageSize = 10, String? search}) async {
    try {
      if (!await _validateToken()) {
        await _clearInvalidToken();
        throw Exception('Invalid or expired token');
      }

      log('Fetching products for category: "$category"');

      final queryParams = <String, String>{
        'category_name': category,
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
        log('Searching category products with query: "$search"');
      }

      final uri = Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY).replace(
        queryParameters: queryParams,
      );
      
      log('Fetching category products from: $uri');

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Cache-Control": "no-cache",
          "Pragma": "no-cache",
        },
      );

      log('Category products response status: ${response.statusCode}');
      log('Category products response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Product> productsForSelectedCategory = [];

        if (jsonResponse['categories'] is List) {
          for (var categoryEntry in jsonResponse['categories']) {
            final categoryName = categoryEntry['category_name']?.toString() ?? '';
            log('Checking category: "$categoryName" against "$category"');
            
            if (categoryName.toLowerCase() == category.toLowerCase()) {
              log('Category match found!');
              if (categoryEntry['products'] is List) {
                final products = (categoryEntry['products'] as List)
                    .map((p) => Product.fromJson(p as Map<String, dynamic>))
                    .toList();
                productsForSelectedCategory.addAll(products);
                log('Added ${products.length} products from main category');
              }

              if (categoryEntry['sub_categories'] is List) {
                for (var subCategoryEntry in categoryEntry['sub_categories']) {
                  if (subCategoryEntry['products'] is List) {
                    final subProducts = (subCategoryEntry['products'] as List)
                        .map((p) => Product.fromJson(p as Map<String, dynamic>))
                        .toList();
                    productsForSelectedCategory.addAll(subProducts);
                    log('Added ${subProducts.length} products from sub-category');
                  }
                }
              }
              break;
            }
          }
        }
        
        log('Total products found for category "$category": ${productsForSelectedCategory.length}');
        return productsForSelectedCategory;
      } else if (response.statusCode == 401) {
        await _clearInvalidToken();
        throw Exception('Unauthorized access');
      } else {
        throw Exception('Failed to fetch category products: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching category products: $e');
      return [];
    }
  }

  Future<List<Product>> searchProducts({
    String? category,
    String? productName,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      if (!await _validateToken()) {
        await _clearInvalidToken();
        throw Exception('Invalid or expired token');
      }

      log('Searching products - Category: "$category", Product Name: "$productName"');

      if (category != null && category.isNotEmpty && category != 'الكل') {
        return await fetchProductsByCategory(
          category,
          page: page,
          pageSize: pageSize,
          search: productName,
        );
      } else {
        return await fetchAllProducts(
          page: page,
          pageSize: pageSize,
          search: productName,
        );
      }
    } catch (e) {
      log('Error searching products: $e');
      return [];
    }
  }

  Future<List<Product>> fetchProductsByBrand(int brandId) async {
    try {
      if (!await _validateToken()) {
        await _clearInvalidToken();
        throw Exception('Invalid or expired token');
      }

      final queryParams = <String, String>{
        'brand_id': brandId.toString(),
      };

      final uri = Uri.parse(APIConstant.GET_PRODUCTS_BY_BRAND).replace(
        queryParameters: queryParams,
      );

      log('Fetching products by brand from: $uri');

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Cache-Control": "no-cache",
          "Pragma": "no-cache",
        },
      );

      log('Brand products response status: ${response.statusCode}');
      log('Brand products response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Product> products = [];
        if (jsonResponse is Map<String, dynamic> && jsonResponse['products'] is List) {
          products = (jsonResponse['products'] as List)
              .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
              .toList();
        }
        log('Parsed ${products.length} products from brand id $brandId');
        return products;
      } else if (response.statusCode == 401) {
        await _clearInvalidToken();
        throw Exception('Unauthorized access');
      } else {
        throw Exception('Failed to fetch products by brand: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching products by brand: $e');
      return [];
    }
  }

  Future<bool> addProductToCart({required int productId, required int quantity, required dynamic price}) async {
    log('addProductToCart called for productId: $productId, quantity: $quantity, price: $price');
    try {
      if (!await _validateToken()) {
        log('Invalid or expired token in addProductToCart');
        return false;
      }
      final response = await http.post(
        Uri.parse(APIConstant.STORE_TO_CART),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
        body: {
          'product_id': productId.toString(),
          'product_quantity': quantity.toString(),
          'price': price.toString(),
        },
      );
      log('POST /api/cart response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('Error in addProductToCart: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchCartFromApi() async {
    log('fetchCartFromApi called');
    try {
      if (!await _validateToken()) {
        log('Invalid or expired token in fetchCartFromApi');
        return [];
      }
      final response = await http.get(
        Uri.parse(APIConstant.GET_STORED_CART),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
      );
      log('Get /api/cart response: \x1B[33m\x1B[1m${response.statusCode}\x1B[0m - ${response.body}');
      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData is List<dynamic>) {
          return decodedData;
        } else {
          log('Unexpected data type from API for cart:  [31m${decodedData.runtimeType} [0m. Expected a List.');
          return [];
        }
      }
      return [];
    } catch (e) {
      log('Error in fetchCartFromApi: $e');
      return [];
    }
  }
}