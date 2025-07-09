import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/main.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';


class CategoryRepository {
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

  Future<List<Product>> fetchAllProducts() async {
    try {
      if (!await _validateToken()) {
        await _clearInvalidToken();
        throw Exception('Invalid or expired token');
      }

      final response = await http.get(
        Uri.parse(APIConstant.GET_ALL_PRODUCTS),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Cache-Control": "no-cache",
          "Pragma": "no-cache",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Product> products = [];

        if (jsonResponse is Map<String, dynamic>) {
          if (jsonResponse['products'] is List) {
            products = (jsonResponse['products'] as List)
                .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
                .toList();
          } else if (jsonResponse['data'] is Map<String, dynamic> &&
              jsonResponse['data']['products'] is List) {
            products = (jsonResponse['data']['products'] as List)
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

  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      if (!await _validateToken()) {
        await _clearInvalidToken();
        throw Exception('Invalid or expired token');
      }

      final response = await http.get(
        Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY).replace(
          queryParameters: {'category_name': category},
        ),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Cache-Control": "no-cache",
          "Pragma": "no-cache",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Product> productsForSelectedCategory = [];

        if (jsonResponse['categories'] is List) {
          for (var categoryEntry in jsonResponse['categories']) {
            if (categoryEntry['category_name']?.toString().toLowerCase() == category.toLowerCase()) {
              if (categoryEntry['products'] is List) {
                final products = (categoryEntry['products'] as List)
                    .map((p) => Product.fromJson(p as Map<String, dynamic>))
                    .toList();
                productsForSelectedCategory.addAll(products);
              }

              if (categoryEntry['sub_categories'] is List) {
                for (var subCategoryEntry in categoryEntry['sub_categories']) {
                  if (subCategoryEntry['products'] is List) {
                    final subProducts = (subCategoryEntry['products'] as List)
                        .map((p) => Product.fromJson(p as Map<String, dynamic>))
                        .toList();
                    productsForSelectedCategory.addAll(subProducts);
                  }
                }
              }
              break;
            }
          }
        }
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
} 